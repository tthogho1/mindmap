// Package model holds pure tree operations over the generated protobuf types.
// Everything here mutates a *mmv1.MindMap in place; persistence, history and
// concurrency are the store's responsibility.
package model

import (
	"crypto/rand"
	"encoding/hex"
	"errors"
	"time"

	mmv1 "mindmap/gen/mindmapv1"
)

var (
	ErrNotFound    = errors.New("node not found")
	ErrRootDelete  = errors.New("cannot delete or move the root node")
	ErrCycle       = errors.New("cannot move a node into itself or one of its descendants")
	ErrNoParent    = errors.New("target parent not found")
)

// NewID returns a short random hex identifier.
func NewID() string {
	b := make([]byte, 8)
	// crypto/rand.Read never returns an error on the platforms we target.
	_, _ = rand.Read(b)
	return hex.EncodeToString(b)
}

// NowMillis is the timestamp unit used across the model.
func NowMillis() int64 { return time.Now().UnixMilli() }

// NewMap builds an empty document with a single root node.
func NewMap(title string) *mmv1.MindMap {
	now := NowMillis()
	if title == "" {
		title = "Untitled"
	}
	return &mmv1.MindMap{
		Id:        NewID(),
		Title:     title,
		CreatedAt: now,
		UpdatedAt: now,
		Root: &mmv1.Node{
			Id:        NewID(),
			Text:      title,
			Color:     "#4A90E2",
			CreatedAt: now,
			UpdatedAt: now,
		},
	}
}

// FindNode returns the node with the given id, searching the root tree and
// every unattached subtree. Returns nil when the id is absent.
func FindNode(m *mmv1.MindMap, id string) *mmv1.Node {
	if m == nil {
		return nil
	}
	if m.Root != nil {
		if m.Root.Id == id {
			return m.Root
		}
		if n, _ := find(m.Root, id); n != nil {
			return n
		}
	}
	for _, u := range m.Unattached {
		if u.Id == id {
			return u
		}
		if n, _ := find(u, id); n != nil {
			return n
		}
	}
	return nil
}

func find(parent *mmv1.Node, id string) (*mmv1.Node, *mmv1.Node) {
	for _, c := range parent.Children {
		if c.Id == id {
			return c, parent
		}
		if n, p := find(c, id); n != nil {
			return n, p
		}
	}
	return nil, nil
}

// detach removes a node (and its whole subtree, intact) from wherever it
// currently lives -- a parent's children, or the top-level unattached list --
// and returns it detached from that location. It does not touch node.ParentId;
// callers set that once they know the new location.
func detach(m *mmv1.MindMap, id string) (*mmv1.Node, error) {
	for i, u := range m.Unattached {
		if u.Id == id {
			m.Unattached = append(m.Unattached[:i:i], m.Unattached[i+1:]...)
			return u, nil
		}
	}
	if m.Root != nil {
		if n, p := find(m.Root, id); n != nil {
			p.Children = removeChild(p.Children, id)
			return n, nil
		}
	}
	for _, u := range m.Unattached {
		if n, p := find(u, id); n != nil {
			p.Children = removeChild(p.Children, id)
			return n, nil
		}
	}
	return nil, ErrNotFound
}

// AddNode creates a node and returns it. When standalone is true, parentID is
// ignored and the node is appended to the map's unattached list instead of
// being placed under a parent. Otherwise it is added as a child of parentID
// (or of root when parentID is empty).
func AddNode(m *mmv1.MindMap, parentID, text string, pos *mmv1.Position, standalone bool) (*mmv1.Node, error) {
	now := NowMillis()
	n := &mmv1.Node{
		Id:        NewID(),
		Text:      text,
		Position:  pos,
		CreatedAt: now,
		UpdatedAt: now,
	}
	if standalone {
		m.Unattached = append(m.Unattached, n)
		touch(m)
		return n, nil
	}
	parent := m.Root
	if parentID != "" && parentID != m.Root.Id {
		p := FindNode(m, parentID)
		if p == nil {
			return nil, ErrNoParent
		}
		parent = p
	}
	n.ParentId = parent.Id
	parent.Children = append(parent.Children, n)
	touch(m)
	return n, nil
}

// DeleteNode removes a node and its whole subtree, wherever it currently
// lives (the root tree or the unattached list).
func DeleteNode(m *mmv1.MindMap, nodeID string) error {
	if m.Root != nil && m.Root.Id == nodeID {
		return ErrRootDelete
	}
	if _, err := detach(m, nodeID); err != nil {
		return err
	}
	touch(m)
	return nil
}

// MoveNode relocates a node (with its subtree intact). When makeStandalone is
// true, newParentID/index are ignored and the node is detached into the map's
// unattached list -- this is how a node is disconnected back to floating.
// Otherwise it is reparented under newParentID, inserted at index among the
// new siblings (index < 0 or beyond the end appends); newParentID may name a
// node in the root tree or in another unattached subtree, which is how a
// standalone node gets linked (or re-linked) into place. pos, when non-nil,
// overrides the node's free position.
func MoveNode(m *mmv1.MindMap, nodeID, newParentID string, index int, pos *mmv1.Position, makeStandalone bool) error {
	if m.Root != nil && m.Root.Id == nodeID {
		return ErrRootDelete
	}
	node := FindNode(m, nodeID)
	if node == nil {
		return ErrNotFound
	}

	// Validate the destination (and the cycle check, which walks node's
	// current children) before detaching -- detach would otherwise pull the
	// node's whole subtree out of the map first, making a target that's one
	// of its own descendants look "not found" instead of a cycle.
	var newParent *mmv1.Node
	if !makeStandalone {
		newParent = m.Root
		if newParentID != "" && newParentID != m.Root.Id {
			p := FindNode(m, newParentID)
			if p == nil {
				return ErrNoParent
			}
			newParent = p
		}
		if newParent.Id == nodeID || isDescendant(node, newParent.Id) {
			return ErrCycle
		}
	}

	if _, err := detach(m, nodeID); err != nil {
		return err
	}
	if pos != nil {
		node.Position = pos
	}
	node.UpdatedAt = NowMillis()

	if makeStandalone {
		node.ParentId = ""
		m.Unattached = append(m.Unattached, node)
		touch(m)
		return nil
	}

	node.ParentId = newParent.Id
	if index < 0 || index > len(newParent.Children) {
		index = len(newParent.Children)
	}
	newParent.Children = append(newParent.Children, nil)
	copy(newParent.Children[index+1:], newParent.Children[index:])
	newParent.Children[index] = node

	touch(m)
	return nil
}

// isDescendant reports whether id is node itself or somewhere in its subtree.
func isDescendant(node *mmv1.Node, id string) bool {
	for _, c := range node.Children {
		if c.Id == id || isDescendant(c, id) {
			return true
		}
	}
	return false
}

func removeChild(children []*mmv1.Node, id string) []*mmv1.Node {
	out := children[:0]
	for _, c := range children {
		if c.Id != id {
			out = append(out, c)
		}
	}
	return out
}

// ResetPositions clears the free position on every node so the client falls
// back to auto-layout.
func ResetPositions(m *mmv1.MindMap) {
	if m == nil {
		return
	}
	if m.Root != nil {
		clearPositions(m.Root)
	}
	for _, u := range m.Unattached {
		clearPositions(u)
	}
	touch(m)
}

func clearPositions(n *mmv1.Node) {
	n.Position = nil
	for _, c := range n.Children {
		clearPositions(c)
	}
}

func touch(m *mmv1.MindMap) { m.UpdatedAt = NowMillis() }

// Summary projects a document down to its listing metadata.
func Summary(m *mmv1.MindMap) *mmv1.MapSummary {
	return &mmv1.MapSummary{
		Id:        m.Id,
		Title:     m.Title,
		CreatedAt: m.CreatedAt,
		UpdatedAt: m.UpdatedAt,
	}
}

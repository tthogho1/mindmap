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

// FindNode returns the node with the given id and its parent (nil parent for
// the root). Both are nil when the id is absent.
func FindNode(m *mmv1.MindMap, id string) (node, parent *mmv1.Node) {
	if m == nil || m.Root == nil {
		return nil, nil
	}
	if m.Root.Id == id {
		return m.Root, nil
	}
	return find(m.Root, id)
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

// AddNode creates a child under parentID (or under root when parentID is
// empty) and returns the new node.
func AddNode(m *mmv1.MindMap, parentID, text string, pos *mmv1.Position) (*mmv1.Node, error) {
	parent := m.Root
	if parentID != "" && parentID != m.Root.Id {
		p, _ := FindNode(m, parentID)
		if p == nil {
			return nil, ErrNoParent
		}
		parent = p
	}
	now := NowMillis()
	n := &mmv1.Node{
		Id:        NewID(),
		ParentId:  parent.Id,
		Text:      text,
		Position:  pos,
		CreatedAt: now,
		UpdatedAt: now,
	}
	parent.Children = append(parent.Children, n)
	touch(m)
	return n, nil
}

// DeleteNode removes a node and its whole subtree.
func DeleteNode(m *mmv1.MindMap, nodeID string) error {
	if m.Root != nil && m.Root.Id == nodeID {
		return ErrRootDelete
	}
	node, parent := FindNode(m, nodeID)
	if node == nil {
		return ErrNotFound
	}
	parent.Children = removeChild(parent.Children, nodeID)
	touch(m)
	return nil
}

// MoveNode reparents a node under newParentID, inserting it at index among the
// new siblings (index < 0 or beyond the end appends). pos, when non-nil,
// overrides the node's free position.
func MoveNode(m *mmv1.MindMap, nodeID, newParentID string, index int, pos *mmv1.Position) error {
	if m.Root != nil && m.Root.Id == nodeID {
		return ErrRootDelete
	}
	node, oldParent := FindNode(m, nodeID)
	if node == nil {
		return ErrNotFound
	}
	newParent := m.Root
	if newParentID != "" && newParentID != m.Root.Id {
		p, _ := FindNode(m, newParentID)
		if p == nil {
			return ErrNoParent
		}
		newParent = p
	}
	if newParent.Id == nodeID || isDescendant(node, newParent.Id) {
		return ErrCycle
	}

	oldParent.Children = removeChild(oldParent.Children, nodeID)
	node.ParentId = newParent.Id
	if pos != nil {
		node.Position = pos
	}
	if index < 0 || index > len(newParent.Children) {
		index = len(newParent.Children)
	}
	newParent.Children = append(newParent.Children, nil)
	copy(newParent.Children[index+1:], newParent.Children[index:])
	newParent.Children[index] = node

	node.UpdatedAt = NowMillis()
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
	if m == nil || m.Root == nil {
		return
	}
	clearPositions(m.Root)
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

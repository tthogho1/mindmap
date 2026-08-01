// Package history keeps bounded undo/redo snapshot stacks for a single
// document. Snapshots are deep clones of the whole map, which keeps the logic
// trivial and correct at the cost of memory — fine for local single-user use.
package history

import (
	mmv1 "mindmap/gen/mindmapv1"
	"google.golang.org/protobuf/proto"
)

const defaultLimit = 100

type History struct {
	undo  []*mmv1.MindMap
	redo  []*mmv1.MindMap
	limit int
}

func New() *History { return &History{limit: defaultLimit} }

func clone(m *mmv1.MindMap) *mmv1.MindMap {
	return proto.Clone(m).(*mmv1.MindMap)
}

// Record pushes the pre-mutation state onto the undo stack and invalidates any
// pending redo. Call this immediately before applying a change.
func (h *History) Record(before *mmv1.MindMap) {
	h.undo = append(h.undo, clone(before))
	if len(h.undo) > h.limit {
		h.undo = h.undo[len(h.undo)-h.limit:]
	}
	h.redo = nil
}

func (h *History) CanUndo() bool { return len(h.undo) > 0 }
func (h *History) CanRedo() bool { return len(h.redo) > 0 }

// Undo returns the previous state, moving current onto the redo stack.
func (h *History) Undo(current *mmv1.MindMap) (*mmv1.MindMap, bool) {
	if len(h.undo) == 0 {
		return nil, false
	}
	prev := h.undo[len(h.undo)-1]
	h.undo = h.undo[:len(h.undo)-1]
	h.redo = append(h.redo, clone(current))
	return prev, true
}

// Redo reapplies the most recently undone state.
func (h *History) Redo(current *mmv1.MindMap) (*mmv1.MindMap, bool) {
	if len(h.redo) == 0 {
		return nil, false
	}
	next := h.redo[len(h.redo)-1]
	h.redo = h.redo[:len(h.redo)-1]
	h.undo = append(h.undo, clone(current))
	return next, true
}

package model

import (
	"testing"

	mmv1 "mindmap/gen/mindmapv1"
)

func TestAddAndFind(t *testing.T) {
	m := NewMap("Root")
	n, err := AddNode(m, "", "Child", nil)
	if err != nil {
		t.Fatalf("AddNode: %v", err)
	}
	if n.ParentId != m.Root.Id {
		t.Fatalf("child parent = %q, want root %q", n.ParentId, m.Root.Id)
	}
	got, parent := FindNode(m, n.Id)
	if got == nil || parent == nil || parent.Id != m.Root.Id {
		t.Fatalf("FindNode returned node=%v parent=%v", got, parent)
	}
}

func TestDeleteSubtree(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil)
	b, _ := AddNode(m, a.Id, "B", nil)
	if err := DeleteNode(m, a.Id); err != nil {
		t.Fatalf("DeleteNode: %v", err)
	}
	if n, _ := FindNode(m, a.Id); n != nil {
		t.Fatal("A still present after delete")
	}
	if n, _ := FindNode(m, b.Id); n != nil {
		t.Fatal("descendant B survived delete")
	}
}

func TestDeleteRootRejected(t *testing.T) {
	m := NewMap("Root")
	if err := DeleteNode(m, m.Root.Id); err != ErrRootDelete {
		t.Fatalf("delete root err = %v, want ErrRootDelete", err)
	}
}

func TestMoveReparents(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil)
	b, _ := AddNode(m, "", "B", nil)
	c, _ := AddNode(m, a.Id, "C", nil)

	if err := MoveNode(m, c.Id, b.Id, -1, nil); err != nil {
		t.Fatalf("MoveNode: %v", err)
	}
	got, parent := FindNode(m, c.Id)
	if got == nil || parent.Id != b.Id {
		t.Fatalf("C parent = %v, want B %q", parent, b.Id)
	}
	if len(a.Children) != 0 {
		t.Fatalf("A still has children after move: %d", len(a.Children))
	}
}

func TestMoveIndex(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil)
	AddNode(m, "", "B", nil)
	// move A to index 0 under root's grandchild? use siblings: insert A at index 1
	if err := MoveNode(m, a.Id, "", 0, nil); err != nil {
		t.Fatalf("MoveNode index: %v", err)
	}
	if m.Root.Children[0].Id != a.Id {
		t.Fatalf("A not at index 0")
	}
}

func TestMoveCycleRejected(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil)
	b, _ := AddNode(m, a.Id, "B", nil)
	// moving A under its own descendant B must fail
	if err := MoveNode(m, a.Id, b.Id, -1, nil); err != ErrCycle {
		t.Fatalf("move into descendant err = %v, want ErrCycle", err)
	}
}

func TestPositionAssign(t *testing.T) {
	m := NewMap("Root")
	n, _ := AddNode(m, "", "A", &mmv1.Position{X: 10, Y: 20})
	if n.Position == nil || n.Position.X != 10 || n.Position.Y != 20 {
		t.Fatalf("position not set: %v", n.Position)
	}
}

func TestResetPositions(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", &mmv1.Position{X: 10, Y: 20})
	b, _ := AddNode(m, a.Id, "B", &mmv1.Position{X: 30, Y: 40})
	ResetPositions(m)
	if a.Position != nil || b.Position != nil {
		t.Fatalf("positions not cleared: a=%v b=%v", a.Position, b.Position)
	}
}

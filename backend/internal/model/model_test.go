package model

import (
	"testing"

	mmv1 "mindmap/gen/mindmapv1"
)

func TestAddAndFind(t *testing.T) {
	m := NewMap("Root")
	n, err := AddNode(m, "", "Child", nil, false)
	if err != nil {
		t.Fatalf("AddNode: %v", err)
	}
	if n.ParentId != m.Root.Id {
		t.Fatalf("child parent = %q, want root %q", n.ParentId, m.Root.Id)
	}
	got := FindNode(m, n.Id)
	if got == nil || got.ParentId != m.Root.Id {
		t.Fatalf("FindNode returned %v", got)
	}
}

func TestDeleteSubtree(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil, false)
	b, _ := AddNode(m, a.Id, "B", nil, false)
	if err := DeleteNode(m, a.Id); err != nil {
		t.Fatalf("DeleteNode: %v", err)
	}
	if n := FindNode(m, a.Id); n != nil {
		t.Fatal("A still present after delete")
	}
	if n := FindNode(m, b.Id); n != nil {
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
	a, _ := AddNode(m, "", "A", nil, false)
	b, _ := AddNode(m, "", "B", nil, false)
	c, _ := AddNode(m, a.Id, "C", nil, false)

	if err := MoveNode(m, c.Id, b.Id, -1, nil, false); err != nil {
		t.Fatalf("MoveNode: %v", err)
	}
	got := FindNode(m, c.Id)
	if got == nil || got.ParentId != b.Id {
		t.Fatalf("C parent = %v, want B %q", got, b.Id)
	}
	if len(a.Children) != 0 {
		t.Fatalf("A still has children after move: %d", len(a.Children))
	}
}

func TestMoveIndex(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil, false)
	AddNode(m, "", "B", nil, false)
	// move A to index 0 under root's grandchild? use siblings: insert A at index 1
	if err := MoveNode(m, a.Id, "", 0, nil, false); err != nil {
		t.Fatalf("MoveNode index: %v", err)
	}
	if m.Root.Children[0].Id != a.Id {
		t.Fatalf("A not at index 0")
	}
}

func TestMoveCycleRejected(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil, false)
	b, _ := AddNode(m, a.Id, "B", nil, false)
	// moving A under its own descendant B must fail
	if err := MoveNode(m, a.Id, b.Id, -1, nil, false); err != ErrCycle {
		t.Fatalf("move into descendant err = %v, want ErrCycle", err)
	}
}

func TestPositionAssign(t *testing.T) {
	m := NewMap("Root")
	n, _ := AddNode(m, "", "A", &mmv1.Position{X: 10, Y: 20}, false)
	if n.Position == nil || n.Position.X != 10 || n.Position.Y != 20 {
		t.Fatalf("position not set: %v", n.Position)
	}
}

func TestResetPositions(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", &mmv1.Position{X: 10, Y: 20}, false)
	b, _ := AddNode(m, a.Id, "B", &mmv1.Position{X: 30, Y: 40}, false)
	u, _ := AddNode(m, "", "U", &mmv1.Position{X: 50, Y: 60}, true)
	ResetPositions(m)
	if a.Position != nil || b.Position != nil || u.Position != nil {
		t.Fatalf("positions not cleared: a=%v b=%v u=%v", a.Position, b.Position, u.Position)
	}
}

func TestAddStandalone(t *testing.T) {
	m := NewMap("Root")
	n, err := AddNode(m, "", "Floating", nil, true)
	if err != nil {
		t.Fatalf("AddNode standalone: %v", err)
	}
	if n.ParentId != "" {
		t.Fatalf("standalone node got a parent: %q", n.ParentId)
	}
	if len(m.Unattached) != 1 || m.Unattached[0].Id != n.Id {
		t.Fatalf("standalone node not in Unattached: %v", m.Unattached)
	}
	if len(m.Root.Children) != 0 {
		t.Fatalf("standalone node leaked into root's children: %v", m.Root.Children)
	}
	if got := FindNode(m, n.Id); got == nil {
		t.Fatal("FindNode did not find the standalone node")
	}
}

func TestLinkStandaloneNode(t *testing.T) {
	m := NewMap("Root")
	target, _ := AddNode(m, "", "Target", nil, false)
	n, _ := AddNode(m, "", "Floating", nil, true)

	if err := MoveNode(m, n.Id, target.Id, -1, nil, false); err != nil {
		t.Fatalf("MoveNode link: %v", err)
	}
	if len(m.Unattached) != 0 {
		t.Fatalf("node still listed as unattached: %v", m.Unattached)
	}
	if n.ParentId != target.Id {
		t.Fatalf("node parent = %q, want %q", n.ParentId, target.Id)
	}
	if len(target.Children) != 1 || target.Children[0].Id != n.Id {
		t.Fatalf("node not attached under target: %v", target.Children)
	}
}

func TestSwitchLink(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil, false)
	b, _ := AddNode(m, "", "B", nil, false)
	n, _ := AddNode(m, "", "Floating", nil, true)

	if err := MoveNode(m, n.Id, a.Id, -1, nil, false); err != nil {
		t.Fatalf("first link: %v", err)
	}
	// Switching the link to a different node reuses the same MoveNode call.
	if err := MoveNode(m, n.Id, b.Id, -1, nil, false); err != nil {
		t.Fatalf("switch link: %v", err)
	}
	if n.ParentId != b.Id {
		t.Fatalf("node parent = %q, want %q", n.ParentId, b.Id)
	}
	if len(a.Children) != 0 {
		t.Fatalf("node still attached to A after switching: %v", a.Children)
	}
	if len(b.Children) != 1 || b.Children[0].Id != n.Id {
		t.Fatalf("node not attached to B: %v", b.Children)
	}
}

func TestDetachToStandalone(t *testing.T) {
	m := NewMap("Root")
	a, _ := AddNode(m, "", "A", nil, false)
	n, _ := AddNode(m, a.Id, "Child", nil, false)

	if err := MoveNode(m, n.Id, "", -1, nil, true); err != nil {
		t.Fatalf("detach: %v", err)
	}
	if n.ParentId != "" {
		t.Fatalf("detached node still has parent: %q", n.ParentId)
	}
	if len(a.Children) != 0 {
		t.Fatalf("A still lists detached child: %v", a.Children)
	}
	if len(m.Unattached) != 1 || m.Unattached[0].Id != n.Id {
		t.Fatalf("detached node not in Unattached: %v", m.Unattached)
	}
}

func TestDetachRootRejected(t *testing.T) {
	m := NewMap("Root")
	if err := MoveNode(m, m.Root.Id, "", -1, nil, true); err != ErrRootDelete {
		t.Fatalf("detach root err = %v, want ErrRootDelete", err)
	}
}

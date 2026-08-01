package store

import (
	"testing"

	"mindmap/internal/model"

	mmv1 "mindmap/gen/mindmapv1"
)

func newStore(t *testing.T) *Store {
	t.Helper()
	s, err := New(t.TempDir())
	if err != nil {
		t.Fatalf("New: %v", err)
	}
	return s
}

func TestCreatePersistsAndReloads(t *testing.T) {
	dir := t.TempDir()
	s, _ := New(dir)
	m, err := s.Create("Doc")
	if err != nil {
		t.Fatalf("Create: %v", err)
	}
	// Reopen from disk and confirm the document survives.
	s2, err := New(dir)
	if err != nil {
		t.Fatalf("reopen: %v", err)
	}
	got, err := s2.Get(m.Id)
	if err != nil {
		t.Fatalf("Get after reload: %v", err)
	}
	if got.Title != "Doc" {
		t.Fatalf("title = %q, want Doc", got.Title)
	}
}

func TestMutateAndUndoRedo(t *testing.T) {
	s := newStore(t)
	m, _ := s.Create("Doc")

	after, err := s.Mutate(m.Id, func(mm *mmv1.MindMap) error {
		_, e := model.AddNode(mm, "", "Child", nil)
		return e
	})
	if err != nil {
		t.Fatalf("Mutate: %v", err)
	}
	if len(after.Root.Children) != 1 {
		t.Fatalf("want 1 child, got %d", len(after.Root.Children))
	}

	undone, err := s.Undo(m.Id)
	if err != nil {
		t.Fatalf("Undo: %v", err)
	}
	if len(undone.Root.Children) != 0 {
		t.Fatalf("undo should remove child, got %d", len(undone.Root.Children))
	}

	redone, err := s.Redo(m.Id)
	if err != nil {
		t.Fatalf("Redo: %v", err)
	}
	if len(redone.Root.Children) != 1 {
		t.Fatalf("redo should restore child, got %d", len(redone.Root.Children))
	}
}

func TestMutateFailureLeavesCacheClean(t *testing.T) {
	s := newStore(t)
	m, _ := s.Create("Doc")
	_, err := s.Mutate(m.Id, func(mm *mmv1.MindMap) error {
		return model.DeleteNode(mm, "does-not-exist")
	})
	if err == nil {
		t.Fatal("expected error deleting missing node")
	}
	got, _ := s.Get(m.Id)
	if got.Root == nil {
		t.Fatal("root damaged by failed mutation")
	}
}

func TestDeleteMap(t *testing.T) {
	s := newStore(t)
	m, _ := s.Create("Doc")
	if _, err := s.Delete(m.Id); err != nil {
		t.Fatalf("Delete: %v", err)
	}
	if _, err := s.Get(m.Id); err != ErrMapNotFound {
		t.Fatalf("Get after delete err = %v, want ErrMapNotFound", err)
	}
}

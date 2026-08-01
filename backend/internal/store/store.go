// Package store owns the collection of documents: an in-memory cache backed by
// one JSON file per map, plus per-map undo/redo history. It is safe for
// concurrent use. All returned maps are deep clones so callers can never mutate
// the cache directly.
package store

import (
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"sync"

	"mindmap/internal/history"
	"mindmap/internal/model"

	mmv1 "mindmap/gen/mindmapv1"
	"google.golang.org/protobuf/encoding/protojson"
	"google.golang.org/protobuf/proto"
)

var ErrMapNotFound = errors.New("map not found")

type Store struct {
	mu   sync.Mutex
	dir  string
	maps map[string]*mmv1.MindMap
	hist map[string]*history.History
}

// New opens (creating if needed) the data directory and loads every *.json
// document it contains into memory.
func New(dir string) (*Store, error) {
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return nil, fmt.Errorf("create data dir: %w", err)
	}
	s := &Store{
		dir:  dir,
		maps: map[string]*mmv1.MindMap{},
		hist: map[string]*history.History{},
	}
	if err := s.loadAll(); err != nil {
		return nil, err
	}
	return s, nil
}

func (s *Store) loadAll() error {
	entries, err := os.ReadDir(s.dir)
	if err != nil {
		return err
	}
	for _, e := range entries {
		if e.IsDir() || filepath.Ext(e.Name()) != ".json" {
			continue
		}
		raw, err := os.ReadFile(filepath.Join(s.dir, e.Name()))
		if err != nil {
			return err
		}
		m := &mmv1.MindMap{}
		if err := protojson.Unmarshal(raw, m); err != nil {
			return fmt.Errorf("parse %s: %w", e.Name(), err)
		}
		s.maps[m.Id] = m
		s.hist[m.Id] = history.New()
	}
	return nil
}

func (s *Store) path(id string) string {
	return filepath.Join(s.dir, id+".json")
}

var marshaler = protojson.MarshalOptions{Multiline: true, Indent: "  ", UseProtoNames: true}

// persist writes a document to disk. Caller holds the lock.
func (s *Store) persist(m *mmv1.MindMap) error {
	raw, err := marshaler.Marshal(m)
	if err != nil {
		return err
	}
	tmp := s.path(m.Id) + ".tmp"
	if err := os.WriteFile(tmp, raw, 0o644); err != nil {
		return err
	}
	return os.Rename(tmp, s.path(m.Id))
}

func cloneMap(m *mmv1.MindMap) *mmv1.MindMap { return proto.Clone(m).(*mmv1.MindMap) }

// List returns metadata for all documents, newest first.
func (s *Store) List() []*mmv1.MapSummary {
	s.mu.Lock()
	defer s.mu.Unlock()
	out := make([]*mmv1.MapSummary, 0, len(s.maps))
	for _, m := range s.maps {
		out = append(out, model.Summary(m))
	}
	sort.Slice(out, func(i, j int) bool { return out[i].UpdatedAt > out[j].UpdatedAt })
	return out
}

func (s *Store) Get(id string) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	m, ok := s.maps[id]
	if !ok {
		return nil, ErrMapNotFound
	}
	return cloneMap(m), nil
}

func (s *Store) Create(title string) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	m := model.NewMap(title)
	s.maps[m.Id] = m
	s.hist[m.Id] = history.New()
	if err := s.persist(m); err != nil {
		return nil, err
	}
	return cloneMap(m), nil
}

// Save replaces a document wholesale (the editor's explicit Save). It records a
// history entry so a save can be undone.
func (s *Store) Save(m *mmv1.MindMap) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if m == nil || m.Id == "" {
		return nil, errors.New("map id required")
	}
	if cur, ok := s.maps[m.Id]; ok {
		s.hist[m.Id].Record(cur)
	} else {
		s.hist[m.Id] = history.New()
	}
	m.UpdatedAt = model.NowMillis()
	stored := cloneMap(m)
	s.maps[m.Id] = stored
	if err := s.persist(stored); err != nil {
		return nil, err
	}
	return cloneMap(stored), nil
}

func (s *Store) Delete(id string) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	m, ok := s.maps[id]
	if !ok {
		return nil, ErrMapNotFound
	}
	delete(s.maps, id)
	delete(s.hist, id)
	if err := os.Remove(s.path(id)); err != nil && !os.IsNotExist(err) {
		return nil, err
	}
	return cloneMap(m), nil
}

// Mutate applies fn to a document under lock, recording a history snapshot
// beforehand and persisting afterward. fn mutates the map in place.
func (s *Store) Mutate(id string, fn func(m *mmv1.MindMap) error) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	m, ok := s.maps[id]
	if !ok {
		return nil, ErrMapNotFound
	}
	// Work on a copy so a failing mutation leaves the cache untouched.
	next := cloneMap(m)
	if err := fn(next); err != nil {
		return nil, err
	}
	s.hist[id].Record(m)
	s.maps[id] = next
	if err := s.persist(next); err != nil {
		return nil, err
	}
	return cloneMap(next), nil
}

func (s *Store) Undo(id string) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	m, ok := s.maps[id]
	if !ok {
		return nil, ErrMapNotFound
	}
	prev, ok := s.hist[id].Undo(m)
	if !ok {
		return cloneMap(m), nil // nothing to undo; return current
	}
	s.maps[id] = prev
	if err := s.persist(prev); err != nil {
		return nil, err
	}
	return cloneMap(prev), nil
}

func (s *Store) Redo(id string) (*mmv1.MindMap, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	m, ok := s.maps[id]
	if !ok {
		return nil, ErrMapNotFound
	}
	next, ok := s.hist[id].Redo(m)
	if !ok {
		return cloneMap(m), nil
	}
	s.maps[id] = next
	if err := s.persist(next); err != nil {
		return nil, err
	}
	return cloneMap(next), nil
}

// Package service adapts gRPC requests onto the store + model. It keeps no
// state of its own beyond the store handle.
package service

import (
	"context"
	"errors"

	"mindmap/internal/model"
	"mindmap/internal/store"

	mmv1 "mindmap/gen/mindmapv1"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type Server struct {
	mmv1.UnimplementedMindMapServiceServer
	store *store.Store
}

func New(s *store.Store) *Server { return &Server{store: s} }

// toStatus translates domain errors into gRPC status errors.
func toStatus(err error) error {
	switch {
	case err == nil:
		return nil
	case errors.Is(err, store.ErrMapNotFound):
		return status.Error(codes.NotFound, err.Error())
	case errors.Is(err, model.ErrNotFound), errors.Is(err, model.ErrNoParent):
		return status.Error(codes.NotFound, err.Error())
	case errors.Is(err, model.ErrRootDelete), errors.Is(err, model.ErrCycle):
		return status.Error(codes.InvalidArgument, err.Error())
	default:
		return status.Error(codes.Internal, err.Error())
	}
}

func (s *Server) CreateMap(_ context.Context, req *mmv1.CreateMapRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Create(req.GetTitle())
	return m, toStatus(err)
}

func (s *Server) GetMap(_ context.Context, req *mmv1.GetMapRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Get(req.GetId())
	return m, toStatus(err)
}

func (s *Server) ListMaps(_ context.Context, _ *mmv1.ListMapsRequest) (*mmv1.ListMapsResponse, error) {
	return &mmv1.ListMapsResponse{Maps: s.store.List()}, nil
}

func (s *Server) SaveMap(_ context.Context, req *mmv1.SaveMapRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Save(req.GetMap())
	return m, toStatus(err)
}

func (s *Server) DeleteMap(_ context.Context, req *mmv1.DeleteMapRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Delete(req.GetId())
	return m, toStatus(err)
}

func (s *Server) AddNode(_ context.Context, req *mmv1.AddNodeRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Mutate(req.GetMapId(), func(m *mmv1.MindMap) error {
		_, err := model.AddNode(m, req.GetParentId(), req.GetText(), req.GetPosition())
		return err
	})
	return m, toStatus(err)
}

func (s *Server) UpdateNode(_ context.Context, req *mmv1.UpdateNodeRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Mutate(req.GetMapId(), func(m *mmv1.MindMap) error {
		node, _ := model.FindNode(m, req.GetNodeId())
		if node == nil {
			return model.ErrNotFound
		}
		if req.Text != nil {
			node.Text = req.GetText()
		}
		if req.Color != nil {
			node.Color = req.GetColor()
		}
		if req.Icon != nil {
			node.Icon = req.GetIcon()
		}
		if req.ImagePath != nil {
			node.ImagePath = req.GetImagePath()
		}
		if req.Collapsed != nil {
			node.Collapsed = req.GetCollapsed()
		}
		if req.Position != nil {
			node.Position = req.GetPosition()
		}
		node.UpdatedAt = model.NowMillis()
		return nil
	})
	return m, toStatus(err)
}

func (s *Server) DeleteNode(_ context.Context, req *mmv1.DeleteNodeRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Mutate(req.GetMapId(), func(m *mmv1.MindMap) error {
		return model.DeleteNode(m, req.GetNodeId())
	})
	return m, toStatus(err)
}

func (s *Server) MoveNode(_ context.Context, req *mmv1.MoveNodeRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Mutate(req.GetMapId(), func(m *mmv1.MindMap) error {
		return model.MoveNode(m, req.GetNodeId(), req.GetNewParentId(), int(req.GetIndex()), req.GetPosition())
	})
	return m, toStatus(err)
}

func (s *Server) ResetLayout(_ context.Context, req *mmv1.ResetLayoutRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Mutate(req.GetMapId(), func(m *mmv1.MindMap) error {
		model.ResetPositions(m)
		return nil
	})
	return m, toStatus(err)
}

func (s *Server) Undo(_ context.Context, req *mmv1.UndoRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Undo(req.GetMapId())
	return m, toStatus(err)
}

func (s *Server) Redo(_ context.Context, req *mmv1.RedoRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Redo(req.GetMapId())
	return m, toStatus(err)
}

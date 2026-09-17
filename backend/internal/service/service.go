// Package service adapts gRPC requests onto the store + model. It keeps no
// state of its own beyond the store handle.
package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"

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

func (s *Server) CreateMapFromPrompt(ctx context.Context, req *mmv1.CreateFromPromptRequest) (*mmv1.MindMap, error) {
	prompt := req.GetPrompt()
	title := req.GetTitleHint()
	if title == "" {
		title = "Untitled"
	}

	// Ask an LLM to generate a JSON structure matching a simple schema.
	jsonText, err := callLLMForJSON(ctx, prompt, title, int(req.GetMaxNodes()))
	if err != nil {
		return nil, toStatus(err)
	}

	// Parse the JSON into a lightweight struct and construct a MindMap.
	var payload struct {
		Title string `json:"title"`
		Root  *struct {
			Id       string        `json:"id"`
			Text     string        `json:"text"`
			Children []interface{} `json:"children"`
		} `json:"root"`
	}
	if err := jsonUnmarshal([]byte(jsonText), &payload); err != nil {
		return nil, toStatus(err)
	}

	// Build a new map and populate nodes.
	m := model.NewMap(payload.Title)

	// Helper to recursively add nodes when child JSON is a map[string]interface{}.
	var addChildren func(parentId string, children []interface{})
	addChildren = func(parentId string, children []interface{}) {
		for _, ci := range children {
			obj, ok := ci.(map[string]interface{})
			if !ok {
				continue
			}
			text, _ := obj["text"].(string)
			node, _ := model.AddNode(m, parentId, text, nil, false)
			if ch, ok := obj["children"].([]interface{}); ok && len(ch) > 0 {
				addChildren(node.Id, ch)
			}
		}
	}

	if payload.Root != nil {
		addChildren(m.Root.Id, payload.Root.Children)
	}

	// Persist and return.
	saved, err := s.store.Save(m)
	return saved, toStatus(err)
}

// Minimal JSON unmarshal wrapper so we can avoid adding new deps in many places.
func jsonUnmarshal(b []byte, v interface{}) error {
	return json.Unmarshal(b, v)
}

// callLLMForJSON calls an LLM (OpenAI) to produce a JSON representation for a
// mind map. It expects the model to return *only* JSON matching the simple
// structure described in the prompt. The server reads `OPENAI_API_KEY` from
// the environment.
func callLLMForJSON(ctx context.Context, prompt, title string, maxNodes int) (string, error) {
	key := os.Getenv("OPENAI_API_KEY")
	if key == "" {
		return "", errors.New("OPENAI_API_KEY not set")
	}

	system := `You are a helpful assistant that returns a JSON object describing a mind map.`
	userPrompt := fmt.Sprintf("Generate a JSON object with fields: title, root (with text and nested children arrays). Title: %s. User prompt: %s. Return only JSON.", title, prompt)

	reqBody := map[string]interface{}{
		"model": "gpt-4o-mini",
		"messages": []map[string]string{
			{"role": "system", "content": system},
			{"role": "user", "content": userPrompt},
		},
		"max_tokens":  1200,
		"temperature": 0.2,
	}
	data, _ := json.Marshal(reqBody)

	req, _ := http.NewRequestWithContext(ctx, "POST", "https://api.openai.com/v1/chat/completions", bytes.NewReader(data))
	req.Header.Set("Authorization", "Bearer "+key)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		b, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("llm error: %s", string(b))
	}
	var out struct {
		Choices []struct {
			Message struct {
				Content string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
	}
	body, _ := io.ReadAll(resp.Body)
	if err := json.Unmarshal(body, &out); err != nil {
		return "", err
	}
	if len(out.Choices) == 0 {
		return "", errors.New("no choices from llm")
	}
	// Try both places: message.content or choices[0].message.content
	j := out.Choices[0].Message.Content
	if j == "" {
		// fallback: try to parse as top-level text
		var asMap map[string]interface{}
		if err := json.Unmarshal(body, &asMap); err == nil {
			if c, ok := asMap["choices"].([]interface{}); ok && len(c) > 0 {
				if chm, ok := c[0].(map[string]interface{}); ok {
					if msg, ok := chm["message"].(map[string]interface{}); ok {
						if cont, ok := msg["content"].(string); ok {
							j = cont
						}
					}
				}
			}
		}
	}
	return j, nil
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
		_, err := model.AddNode(m, req.GetParentId(), req.GetText(), req.GetPosition(), req.GetStandalone())
		return err
	})
	return m, toStatus(err)
}

func (s *Server) UpdateNode(_ context.Context, req *mmv1.UpdateNodeRequest) (*mmv1.MindMap, error) {
	m, err := s.store.Mutate(req.GetMapId(), func(m *mmv1.MindMap) error {
		node := model.FindNode(m, req.GetNodeId())
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
		return model.MoveNode(m, req.GetNodeId(), req.GetNewParentId(), int(req.GetIndex()), req.GetPosition(), req.GetMakeStandalone())
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

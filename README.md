# Mind Map

A standalone, offline-first mind map app: a **Flutter** desktop UI over a **Go**
core engine, talking **gRPC** on localhost. The Go side owns the tree model,
node CRUD, JSON persistence and undo/redo; Flutter owns the canvas, editing and
PNG export.

## Architecture

```
┌────────────────────────┐        gRPC / HTTP2        ┌───────────────────────────┐
│  Flutter (frontend/)    │  127.0.0.1:50051           │  Go core (backend/)        │
│  • canvas + pan/zoom     │ ─────────────────────────▶ │  • tree model & CRUD       │
│  • drag-to-reparent      │                            │  • move / collapse         │
│  • collapse / expand     │  every mutating RPC        │  • undo / redo history     │
│  • node editor dialog    │  returns the full MindMap  │  • JSON file per document  │
│  • PNG export            │ ◀───────────────────────── │                            │
└────────────────────────┘                            └───────────────────────────┘
```

The wire contract is one proto file, `proto/mindmap.proto`, from which both the
Go and Dart stubs are generated. Every mutating RPC returns the **entire**
up-to-date document, so the UI never has to reconstruct state — it just replaces
the tree it renders.

## Layout

| Path | What |
|---|---|
| `proto/mindmap.proto` | Single source of truth for messages + `MindMapService`. |
| `backend/` | Go module `mindmap`. gRPC server + core engine. |
| `backend/internal/model` | Pure tree operations (add/delete/move/find). |
| `backend/internal/store` | In-memory cache, JSON persistence, per-map history. |
| `backend/internal/history` | Undo/redo snapshot stacks. |
| `backend/internal/service` | gRPC adapter over store + model. |
| `backend/gen/mindmapv1` | Generated Go code (checked in). |
| `frontend/` | Flutter app (macOS desktop target). |
| `frontend/lib/generated` | Generated Dart code (checked in). |
| `frontend/lib/state` | `AppState` — the single `ChangeNotifier`. |
| `frontend/lib/widgets` | Canvas, node cards, edge painter. |
| `frontend/tool/e2e.dart` | Live gRPC round-trip check against a running server. |
| `scripts/gen.sh` | Regenerate Go + Dart from the proto. |
| `scripts/dev.sh` | Start server + launch the Flutter app. |

## Prerequisites

- Go 1.25+
- Flutter 3.44+ (with macOS desktop enabled: `flutter config --enable-macos-desktop`)
- For regenerating code only:
  - `protoc`
  - Go plugins: `go install google.golang.org/protobuf/cmd/protoc-gen-go@latest`
    and `google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest`
  - Dart plugin: `dart pub global activate protoc_plugin 22.3.0`
    **(pin 22.3.0 — it targets the protobuf 4.x runtime that `grpc` depends on;
    25.x emits code needing protobuf 6.x, which `grpc` does not yet allow.)**

## Run

```bash
# one-shot: starts the Go core, then the Flutter desktop app
./scripts/dev.sh
```

or manually, in two terminals:

```bash
# terminal 1 — core
cd backend && go run . -addr 127.0.0.1:50051
#   maps are stored as JSON under ~/.mindmap/maps (override with -data-dir)

# terminal 2 — UI
cd frontend && flutter run -d macos
```

## Test

```bash
cd backend && go test ./...          # model + store unit tests
cd frontend && flutter test          # Dart unit tests
cd frontend && flutter analyze       # static analysis (clean)

# live end-to-end: real Dart client ↔ real Go server
cd backend && go run . -addr 127.0.0.1:50099 &
cd frontend && dart run tool/e2e.dart 50099
```

## Editor controls

- **Tab** — add child of the selected node
- **Enter** — add sibling
- **Delete / Backspace** — delete selected node (and its subtree)
- **Cmd+Z / Cmd+Shift+Z** — undo / redo
- **Double-click a node** — edit text, color, icon
- **Drag a node onto another** — reparent it
- **Drag a node onto empty canvas** — pin it to a free position; its whole
  branch moves with it while unpinned branches keep auto-flowing
- **± button on a node** — collapse / expand its subtree
- Toolbar (top-right): reset view, **reset layout** (clear all pinned
  positions), export PNG

## MVP status

Done: create/edit/delete nodes · drag-to-reparent · free-position dragging (pin
a node/branch anywhere; reset layout to clear) · collapse/expand · local
save/load · PNG export · basic desktop UI · undo/redo.

Roadmap (per the spec): PDF export · search · templates · mobile targets ·
collaboration / cloud sync.

## Notes & deviations from the original spec

- **Communication is gRPC**, not the REST endpoints sketched in the spec, for
  stronger typing across the language boundary.
- **PNG export happens in Flutter** (`RepaintBoundary` → image) rather than in
  Go: it captures exactly what's on the canvas and avoids re-implementing layout
  + rendering server-side. Layout is likewise computed client-side (a small tidy
  tree in `frontend/lib/layout`).
- Generated code for both languages is checked in so a fresh clone runs without
  needing `protoc`.

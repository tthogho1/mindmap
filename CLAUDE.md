# CLAUDE.md — mindmap

Standalone mind map app: **Flutter** desktop UI + **Go** core, over **gRPC** on
localhost. See `README.md` for the full picture; this file is the fast path for
working in the code.

## Structure

- `proto/mindmap.proto` — the one wire contract. Change it here, then regenerate.
- `backend/` — Go module `mindmap` (the gRPC server + engine).
- `frontend/` — Flutter app; macOS desktop is the active target.
- Generated code (`backend/gen/mindmapv1`, `frontend/lib/generated`) is **checked
  in**. Regenerate with `./scripts/gen.sh` after editing the proto — never hand-edit.

## Key design invariants

- **Every mutating RPC returns the whole `MindMap`.** The Go service mutates a
  clone, records a history snapshot, persists, then returns a fresh clone. The
  Flutter `AppState` just replaces `current` with the response. Preserve this —
  it's why the UI needs no client-side tree patching.
- **The store owns concurrency, persistence and history**
  (`backend/internal/store`). `model/` is pure tree logic with no I/O. `service/`
  is a thin gRPC adapter. Keep those roles separate.
- One JSON file per document under `~/.mindmap/maps` (protojson, `UseProtoNames`).
- Undo/redo = deep-clone snapshots (`internal/history`), simple and correct.
- **Layout is hybrid** (`frontend/lib/layout/tree_layout.dart`): a tidy-tree
  auto-pass, then any node with a set `position` snaps to it and shifts its whole
  subtree by the delta. A pinned node is signalled purely by `hasPosition()`;
  clearing a pin needs the dedicated `ResetLayout` RPC (UpdateNode can only set,
  not clear, an optional message field).

## Build / test / run

```bash
cd backend && go build ./... && go test ./...
cd frontend && flutter analyze && flutter test
cd frontend && flutter build macos --debug     # confirm native build
./scripts/dev.sh                                # server + app together
```

Live end-to-end (real Dart client ↔ real Go server), the highest-signal check:

```bash
cd backend && go run . -addr 127.0.0.1:50099 &
cd frontend && dart run tool/e2e.dart 50099
```

## Gotchas

- **Dart protoc plugin must be `protoc_plugin` 22.3.0.** It targets protobuf
  4.x, which matches `grpc`'s dependency. Version 25.x emits code that needs
  protobuf 6.x and will fail to analyze against `grpc` 4.x.
- macOS is sandboxed: the app needs `com.apple.security.network.client` (gRPC)
  and `files.user-selected.read-write` (PNG export) in both
  `macos/Runner/*.entitlements`. They're already set — keep them if you
  regenerate the macOS runner.
- PNG export and tree layout live in Flutter, not Go (see README deviations).

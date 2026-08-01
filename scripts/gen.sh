#!/usr/bin/env bash
# Regenerate Go and Dart code from proto/mindmap.proto.
#
# Requires: protoc, protoc-gen-go, protoc-gen-go-grpc (Go plugins on PATH),
# and protoc-gen-dart from `dart pub global activate protoc_plugin 22.3.0`
# (that version targets the protobuf 4.x runtime that grpc 4.x depends on —
# do NOT use protoc_plugin 25.x, its output needs protobuf 6.x).
set -euo pipefail
cd "$(dirname "$0")/.."

export PATH="$PATH:$(go env GOPATH)/bin:$HOME/.pub-cache/bin"

echo "==> Go"
protoc --proto_path=proto \
  --go_out=backend --go_opt=module=mindmap \
  --go-grpc_out=backend --go-grpc_opt=module=mindmap \
  proto/mindmap.proto

echo "==> Dart"
protoc --proto_path=proto \
  --dart_out=grpc:frontend/lib/generated \
  proto/mindmap.proto

echo "Done."

#!/usr/bin/env bash
# Start the Go core, then launch the Flutter desktop app pointed at it.
# The server keeps running until you quit; Ctrl-C stops both.
set -euo pipefail
cd "$(dirname "$0")/.."

ADDR="${MINDMAP_ADDR:-127.0.0.1:50051}"

echo "==> starting Go server on $ADDR"
( cd backend && go run . -addr "$ADDR" ) &
SERVER_PID=$!
trap 'kill $SERVER_PID 2>/dev/null || true' EXIT

sleep 1
echo "==> launching Flutter (macOS)"
( cd frontend && flutter run -d macos )

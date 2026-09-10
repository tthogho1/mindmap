#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTDIR="$ROOT/build/bin"
mkdir -p "$OUTDIR"
EXT=""
LDFLAGS=""
# Detect Windows targets
if [ "${GOOS:-}" = "windows" ] || [ "${TARGET_OS:-}" = "windows" ]; then
  EXT=".exe"
  # GUI subsystem: no console window when the app launches the server.
  LDFLAGS="-H=windowsgui"
fi
echo "Building backend package..."
cd "$ROOT/backend"
go build -ldflags "$LDFLAGS" -o "$OUTDIR/mindmap-server${EXT}" .
echo "Built $OUTDIR/mindmap-server${EXT}"

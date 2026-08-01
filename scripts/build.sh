#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTDIR="$ROOT/build/bin"
mkdir -p "$OUTDIR"
EXT=""
# Detect Windows targets
if [ "${GOOS:-}" = "windows" ] || [ "${TARGET_OS:-}" = "windows" ]; then
  EXT=".exe"
fi
echo "Building backend package..."
cd "$ROOT/backend"
go build -o "$OUTDIR/mindmap-server${EXT}" .
echo "Built $OUTDIR/mindmap-server${EXT}"

Mermaid converter
=================

Simple CLI to convert a stored proto-JSON `MindMap` into Mermaid graph syntax.

Usage
-----

Build and run:

```bash
go run ./backend/cmd/mermaid -in /path/to/map.json -out map.mmd
```

Or read from stdin and write to stdout:

```bash
cat /path/to/map.json | go run ./backend/cmd/mermaid > map.mmd
```

Flags:

- `-in` input proto-JSON file (use `-` for stdin)
- `-out` output file (use `-` for stdout)
- `-dir` Mermaid graph direction (default `TD`)
- `-title` include the map title as a comment (default `true`)

The tool expects the same proto JSON format that the server persists (see `backend/internal/store`).

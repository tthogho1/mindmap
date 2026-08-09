package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"strings"

	mmv1 "mindmap/gen/mindmapv1"

	"google.golang.org/protobuf/encoding/protojson"
)

func main() {
	in := flag.String("in", "-", "input proto-JSON file ('-' for stdin)")
	out := flag.String("out", "-", "output file ('-' for stdout)")
	dir := flag.String("dir", "TD", "graph direction for Mermaid (TD, LR, etc.)")
	includeTitle := flag.Bool("title", true, "include map title as comment")
	flag.Parse()

	var raw []byte
	var err error
	if *in == "-" {
		raw, err = io.ReadAll(os.Stdin)
	} else {
		raw, err = os.ReadFile(*in)
	}
	if err != nil {
		fmt.Fprintln(os.Stderr, "read input:", err)
		os.Exit(2)
	}

	m := &mmv1.MindMap{}
	if err := protojson.Unmarshal(raw, m); err != nil {
		fmt.Fprintln(os.Stderr, "parse:", err)
		os.Exit(2)
	}

	var w io.Writer = os.Stdout
	if *out != "-" {
		f, err := os.Create(*out)
		if err != nil {
			fmt.Fprintln(os.Stderr, "create output:", err)
			os.Exit(2)
		}
		defer f.Close()
		w = f
	}

	if *includeTitle && m.Title != "" {
		fmt.Fprintf(w, "%% %s\n\n", m.Title)
	}
	fmt.Fprintf(w, "graph %s\n", *dir)

	printed := make(map[string]bool)

	var recurse func(n *mmv1.Node)
	recurse = func(n *mmv1.Node) {
		sid := sanitizeID(n.Id)
		if sid == "" {
			// fallback unique label
			sid = "node_" + fmt.Sprintf("%p", n)
		}
		if !printed[n.Id] {
			fmt.Fprintf(w, "  %s[\"%s\"]\n", sid, escapeLabel(n.Text))
			printed[n.Id] = true
		}
		for _, c := range n.Children {
			csid := sanitizeID(c.Id)
			if csid == "" {
				csid = "node_" + fmt.Sprintf("%p", c)
			}
			if !printed[c.Id] {
				fmt.Fprintf(w, "  %s[\"%s\"]\n", csid, escapeLabel(c.Text))
				printed[c.Id] = true
			}
			fmt.Fprintf(w, "  %s --> %s\n", sid, csid)
			recurse(c)
		}
	}

	if m.Root != nil {
		recurse(m.Root)
	} else {
		fmt.Fprintln(w, "  empty_root[\"(empty)\"]")
	}
}

func sanitizeID(s string) string {
	if s == "" {
		return ""
	}
	var b strings.Builder
	for i, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || (r >= '0' && r <= '9') || r == '_' {
			b.WriteRune(r)
		} else {
			b.WriteByte('_')
		}
		_ = i
	}
	out := b.String()
	if out == "" {
		return ""
	}
	// Mermaid ids must not start with a digit
	first := out[0]
	if first >= '0' && first <= '9' {
		out = "n" + out
	}
	return out
}

func escapeLabel(s string) string {
	if s == "" {
		return ""
	}
	s = strings.ReplaceAll(s, "\"", "\\\"")
	s = strings.ReplaceAll(s, "\n", " ")
	return s
}

import 'dart:convert';

import 'package:file_selector/file_selector.dart';

import '../generated/mindmap.pb.dart';

/// Converts a [MindMap] to Mermaid graph syntax and prompts the user to save
/// it. Returns the written path, or null if cancelled.
Future<String?> exportMindMapToMermaid(MindMap map, String suggestedName) async {
  final buf = StringBuffer();
  if (map.title.isNotEmpty) {
    buf.writeln('%% ${map.title}');
    buf.writeln();
  }
  buf.writeln('graph TD');

  String sanitizeId(String s) {
    if (s.isEmpty) return '';
    final b = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final r = s.codeUnitAt(i);
      if ((r >= 0x61 && r <= 0x7A) || (r >= 0x41 && r <= 0x5A) || (r >= 0x30 && r <= 0x39) || r == 0x5F) {
        b.writeCharCode(r);
      } else {
        b.write('_');
      }
    }
    var out = b.toString();
    if (out.isEmpty) return '';
    if (out.codeUnitAt(0) >= 0x30 && out.codeUnitAt(0) <= 0x39) out = 'n$out';
    return out;
  }

  String escapeLabel(String s) => s.replaceAll('"', '\\"').replaceAll('\n', ' ');

  final printed = <String>{};

  void recurse(Node n) {
    final sid = sanitizeId(n.id);
    final nodeId = sid.isEmpty ? 'node_${n.hashCode}' : sid;
    if (!printed.contains(n.id)) {
      buf.writeln('  $nodeId["${escapeLabel(n.text)}"]');
      printed.add(n.id);
    }
    for (final c in n.children) {
      final csid = sanitizeId(c.id);
      final childId = csid.isEmpty ? 'node_${c.hashCode}' : csid;
      if (!printed.contains(c.id)) {
        buf.writeln('  $childId["${escapeLabel(c.text)}"]');
        printed.add(c.id);
      }
      buf.writeln('  $nodeId --> $childId');
      recurse(c);
    }
  }

  if (map.hasRoot()) {
    recurse(map.root);
  } else {
    buf.writeln('  empty_root["(empty)"]');
  }

  final content = utf8.encode(buf.toString());
  var name = suggestedName;
  if (!name.toLowerCase().endsWith('.mmd')) name = '$name.mmd';

  final location = await getSaveLocation(
    acceptedTypeGroups: const [
      XTypeGroup(label: 'Mermaid', extensions: ['mmd', 'md', 'txt']),
    ],
    suggestedName: name,
  );
  if (location == null) return null;

  final file = XFile.fromData(content, mimeType: 'text/plain', name: name);
  await file.saveTo(location.path);
  return location.path;
}

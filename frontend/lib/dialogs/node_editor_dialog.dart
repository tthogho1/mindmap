import 'package:flutter/material.dart';

import '../generated/mindmap.pb.dart';
import '../widgets/node_card.dart';

/// Result of editing a node in the dialog.
class NodeEdit {
  NodeEdit(this.text, this.color, this.icon);
  final String text;
  final String color;
  final String icon;
}

const _palette = [
  '#4A90E2', '#50C878', '#E2A64A', '#E24A6A',
  '#9B59B6', '#1ABC9C', '#34495E', '#E67E22',
];

const _icons = ['', '💡', '⭐', '🎯', '✅', '🚀', '📌', '⚠️'];

/// Modal for editing a node's text, color and icon. Returns null on cancel.
Future<NodeEdit?> showNodeEditor(BuildContext context, Node node) {
  final controller = TextEditingController(text: node.text);
  var color = node.color.isEmpty ? _palette.first : node.color;
  var icon = node.icon;

  return showDialog<NodeEdit>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit node'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Text',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => Navigator.pop(
                        context, NodeEdit(controller.text, color, icon)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Color'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in _palette)
                        GestureDetector(
                          onTap: () => setState(() => color = c),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorFromHex(c, Colors.blue),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color == c
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Icon'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final i in _icons)
                        ChoiceChip(
                          label: Text(i.isEmpty ? 'none' : i),
                          selected: icon == i,
                          onSelected: (_) => setState(() => icon = i),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                    context, NodeEdit(controller.text, color, icon)),
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

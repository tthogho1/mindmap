import 'package:flutter/material.dart';

import '../generated/mindmap.pb.dart';
import '../layout/tree_layout.dart';

Color colorFromHex(String hex, Color fallback) {
  var h = hex.replaceAll('#', '').trim();
  if (h.length == 6) h = 'FF$h';
  final v = int.tryParse(h, radix: 16);
  return v == null ? fallback : Color(v);
}

/// A single node box: a Draggable source (payload = node id) that is also a
/// DragTarget so another node can be dropped onto it to reparent.
class NodeCard extends StatelessWidget {
  const NodeCard({
    super.key,
    required this.node,
    required this.selected,
    required this.onTap,
    required this.onDoubleTap,
    required this.onToggleCollapse,
    required this.onReparent,
    required this.onDragEnd,
  });

  final Node node;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onToggleCollapse;
  final void Function(String draggedId) onReparent;

  /// Fired when a drag of this node ends. The canvas decides whether it was
  /// dropped on empty space (→ pin a free position) or on another node
  /// (→ reparent, in which case [DraggableDetails.wasAccepted] is true).
  final void Function(DraggableDetails details) onDragEnd;

  @override
  Widget build(BuildContext context) {
    final base = colorFromHex(node.color, const Color(0xFF4A90E2));

    return DragTarget<String>(
      onWillAcceptWithDetails: (d) => d.data != node.id,
      onAcceptWithDetails: (d) => onReparent(d.data),
      builder: (context, candidate, rejected) {
        final highlighted = candidate.isNotEmpty;
        final card = _card(context, base, highlighted);
        return Draggable<String>(
          data: node.id,
          onDragEnd: onDragEnd,
          feedback: Opacity(opacity: 0.85, child: _card(context, base, false)),
          childWhenDragging: Opacity(opacity: 0.35, child: card),
          child: card,
        );
      },
    );
  }

  Widget _card(BuildContext context, Color base, bool highlighted) {
    final childCount = node.children.length;
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        width: kNodeWidth,
        height: kNodeHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: base.withValues(alpha: highlighted ? 0.95 : 0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.white : base.withValues(alpha: 0.9),
            width: selected ? 3 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            if (node.icon.isNotEmpty) ...[
              Text(node.icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: Text(
                node.text.isEmpty ? '(empty)' : node.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            if (childCount > 0)
              GestureDetector(
                onTap: onToggleCollapse,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    node.collapsed ? Icons.add_circle : Icons.remove_circle,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

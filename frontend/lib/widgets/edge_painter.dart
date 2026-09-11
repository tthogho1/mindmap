import 'package:flutter/material.dart';

import '../generated/mindmap.pb.dart';
import '../layout/tree_layout.dart';

/// Draws the connector curves from each visible node to its visible children,
/// for the root tree and, separately, for every unattached node's own
/// subtree. Unattached nodes are never connected to the root tree itself --
/// that's the point of them being unattached -- so each entry in [roots] is
/// painted as its own independent group.
class EdgePainter extends CustomPainter {
  EdgePainter({
    required this.roots,
    required this.positions,
    required this.visible,
    required this.color,
  });

  final List<Node> roots;
  final Map<String, Offset> positions;
  final Set<String> visible;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (final root in roots) {
      _paintNode(canvas, root, paint);
    }
  }

  void _paintNode(Canvas canvas, Node n, Paint paint) {
    if (n.collapsed) return;
    final from = positions[n.id];
    if (from == null) return;
    final start = Offset(from.dx + kNodeWidth, from.dy);
    for (final c in n.children) {
      final to = positions[c.id];
      if (to == null || !visible.contains(c.id)) continue;
      final end = Offset(to.dx, to.dy);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(
          start.dx + (end.dx - start.dx) / 2, start.dy,
          start.dx + (end.dx - start.dx) / 2, end.dy,
          end.dx, end.dy,
        );
      canvas.drawPath(path, paint);
      _paintNode(canvas, c, paint);
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter old) =>
      old.positions != positions || old.color != color || old.roots != roots;
}

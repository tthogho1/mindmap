import 'package:flutter/widgets.dart';

import '../generated/mindmap.pb.dart';

/// Fixed node box size used both for layout spacing and rendering.
const double kNodeWidth = 168;
const double kNodeHeight = 52;

/// Result of laying out a tree: the canvas extent plus, for every visible node,
/// the offset of its left edge / vertical center.
class TreeLayoutResult {
  TreeLayoutResult(this.positions, this.size, this.visible);

  /// Left-edge x, vertical-center y per node id.
  final Map<String, Offset> positions;
  final Size size;
  final Set<String> visible;
}

/// Hybrid layout. First a minimal "tidy tree" pass assigns every visible node a
/// default position (depth drives x, a running leaf counter drives y, internal
/// nodes center on their children). A second pass then honors any node with an
/// explicit free [Node.position]: that node snaps to its pinned coordinates and
/// its whole subtree shifts by the same delta, so a dragged branch stays intact
/// while unpinned branches keep flowing automatically.
class TreeLayout {
  TreeLayout({this.hGap = 240, this.vGap = 68, this.margin = 48});

  final double hGap;
  final double vGap;
  final double margin;

  final Map<String, Offset> _auto = {};
  final Set<String> _visible = {};
  double _nextY = 0;

  TreeLayoutResult layout(Node root) {
    _auto.clear();
    _visible.clear();
    _nextY = margin;
    _computeAuto(root, 0);

    final effective = <String, Offset>{};
    _place(root, Offset.zero, effective);

    var maxX = 0.0, maxY = 0.0;
    for (final id in _visible) {
      final p = effective[id]!;
      if (p.dx > maxX) maxX = p.dx;
      if (p.dy > maxY) maxY = p.dy;
    }
    return TreeLayoutResult(
      effective,
      Size(maxX + kNodeWidth + margin, maxY + kNodeHeight + margin),
      Set.of(_visible),
    );
  }

  double _computeAuto(Node n, int depth) {
    _visible.add(n.id);
    final x = margin + depth * hGap;
    double y;
    final hasVisibleChildren = !n.collapsed && n.children.isNotEmpty;
    if (!hasVisibleChildren) {
      y = _nextY;
      _nextY += vGap;
    } else {
      final first = _computeAuto(n.children.first, depth + 1);
      double last = first;
      for (var i = 1; i < n.children.length; i++) {
        last = _computeAuto(n.children[i], depth + 1);
      }
      y = (first + last) / 2;
    }
    _auto[n.id] = Offset(x, y);
    return y;
  }

  void _place(Node n, Offset inheritedDelta, Map<String, Offset> out) {
    final auto = _auto[n.id]!;
    Offset finalPos;
    Offset delta;
    if (n.hasPosition()) {
      finalPos = Offset(n.position.x, n.position.y);
      delta = finalPos - auto; // this node's own displacement, passed to kids
    } else {
      finalPos = auto + inheritedDelta;
      delta = inheritedDelta;
    }
    out[n.id] = finalPos;
    if (n.collapsed) return;
    for (final c in n.children) {
      _place(c, delta, out);
    }
  }
}

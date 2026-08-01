import 'package:flutter/material.dart';

import '../generated/mindmap.pb.dart';
import '../layout/tree_layout.dart';
import 'edge_painter.dart';
import 'node_card.dart';

/// Renders the whole tree: pan/zoomable, with connector curves and draggable
/// node cards. [boundaryKey] wraps the full-size content so it can be captured
/// to PNG at its true extent (not just the visible viewport).
class MindMapCanvas extends StatelessWidget {
  const MindMapCanvas({
    super.key,
    required this.map,
    required this.selectedId,
    required this.boundaryKey,
    required this.transformationController,
    required this.onSelect,
    required this.onEdit,
    required this.onToggleCollapse,
    required this.onReparent,
    required this.onFreePosition,
  });

  final MindMap map;
  final String? selectedId;
  final GlobalKey boundaryKey;
  final TransformationController transformationController;
  final void Function(String id) onSelect;
  final void Function(Node node) onEdit;
  final void Function(String id) onToggleCollapse;
  final void Function(String draggedId, String targetId) onReparent;

  /// Called with a node's new pinned position, in canvas coordinates
  /// (left-edge x, vertical-center y).
  final void Function(String id, Offset canvasPos) onFreePosition;

  @override
  Widget build(BuildContext context) {
    final result = TreeLayout().layout(map.root);
    final nodes = <String, Node>{};
    _collect(map.root, nodes);

    return InteractiveViewer(
      transformationController: transformationController,
      constrained: false,
      minScale: 0.2,
      maxScale: 3.0,
      boundaryMargin: const EdgeInsets.all(600),
      child: RepaintBoundary(
        key: boundaryKey,
        child: Container(
          width: result.size.width,
          height: result.size.height,
          color: Theme.of(context).colorScheme.surface,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: EdgePainter(
                    root: map.root,
                    positions: result.positions,
                    visible: result.visible,
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
              for (final id in result.visible)
                if (nodes[id] != null && result.positions[id] != null)
                  Positioned(
                    left: result.positions[id]!.dx,
                    top: result.positions[id]!.dy - kNodeHeight / 2,
                    child: NodeCard(
                      node: nodes[id]!,
                      selected: id == selectedId,
                      onTap: () => onSelect(id),
                      onDoubleTap: () => onEdit(nodes[id]!),
                      onToggleCollapse: () => onToggleCollapse(id),
                      onReparent: (draggedId) => onReparent(draggedId, id),
                      onDragEnd: (details) => _handleDragEnd(id, details),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  /// Turns a finished drag into a pinned free position, unless the node was
  /// dropped onto another node (which reparents instead).
  void _handleDragEnd(String id, DraggableDetails details) {
    if (details.wasAccepted) return; // handled by a DragTarget → reparented
    final box = boundaryKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    // details.offset is the node's global top-left at release; globalToLocal
    // undoes the pan/zoom transform to give canvas coordinates.
    final topLeft = box.globalToLocal(details.offset);
    const minEdge = 8.0;
    final x = topLeft.dx < minEdge ? minEdge : topLeft.dx;
    final centerY = topLeft.dy + kNodeHeight / 2;
    final minCenterY = minEdge + kNodeHeight / 2;
    onFreePosition(id, Offset(x, centerY < minCenterY ? minCenterY : centerY));
  }

  void _collect(Node n, Map<String, Node> out) {
    out[n.id] = n;
    for (final c in n.children) {
      _collect(c, out);
    }
  }
}

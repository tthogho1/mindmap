import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../dialogs/node_editor_dialog.dart';
import '../services/png_export.dart';
import '../state/app_state.dart';
import '../widgets/mindmap_canvas.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _boundaryKey = GlobalKey();
  final _transform = TransformationController();
  final _focus = FocusNode();
  String? _shownError;

  @override
  void initState() {
    super.initState();
    context.read<AppState>().addListener(_onStateChanged);
  }

  @override
  void dispose() {
    context.read<AppState>().removeListener(_onStateChanged);
    _transform.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    final err = context.read<AppState>().lastError;
    if (err != null && err != _shownError && mounted) {
      _shownError = err;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text(err)));
    }
    if (err == null) _shownError = null;
  }

  Future<void> _exportPng() async {
    final state = context.read<AppState>();
    final name = '${state.current?.title ?? 'mindmap'}.png';
    final path = await exportBoundaryToPng(_boundaryKey, name);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(path == null ? 'Export cancelled' : 'Saved to $path')),
    );
  }

  Future<void> _editSelected() async {
    final state = context.read<AppState>();
    final node = state.selectedNode;
    if (node == null) return;
    final result = await showNodeEditor(context, node);
    if (result != null) {
      await state.updateNode(node.id,
          text: result.text, color: result.color, icon: result.icon);
    }
  }

  void _resetView() => _transform.value = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final map = state.current;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Home',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(map?.title ?? 'Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo (Cmd+Z)',
            onPressed: state.undo,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            tooltip: 'Redo (Cmd+Shift+Z)',
            onPressed: state.redo,
          ),
          const VerticalDivider(),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            tooltip: 'Reset view',
            onPressed: _resetView,
          ),
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'Reset layout (clear pinned positions)',
            onPressed: state.resetLayout,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Export PNG',
            onPressed: _exportPng,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: _Toolbar(
        onAddChild: () => state.addChild(),
        onAddSibling: () => state.addSibling(),
        onEdit: _editSelected,
        onDelete: () {
          final id = state.selectedNodeId;
          if (id != null && id != map?.root.id) state.deleteNode(id);
        },
      ),
      body: map == null
          ? const Center(child: Text('No map open'))
          : CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.tab): () =>
                    state.addChild(),
                const SingleActivator(LogicalKeyboardKey.enter): () =>
                    state.addSibling(),
                const SingleActivator(LogicalKeyboardKey.delete): () {
                  final id = state.selectedNodeId;
                  if (id != null && id != map.root.id) state.deleteNode(id);
                },
                const SingleActivator(LogicalKeyboardKey.backspace): () {
                  final id = state.selectedNodeId;
                  if (id != null && id != map.root.id) state.deleteNode(id);
                },
                const SingleActivator(LogicalKeyboardKey.keyZ, meta: true):
                    state.undo,
                const SingleActivator(LogicalKeyboardKey.keyZ,
                    meta: true, shift: true): state.redo,
              },
              child: Focus(
                focusNode: _focus,
                autofocus: true,
                child: MindMapCanvas(
                  map: map,
                  selectedId: state.selectedNodeId,
                  boundaryKey: _boundaryKey,
                  transformationController: _transform,
                  onSelect: state.select,
                  onEdit: (node) async {
                    state.select(node.id);
                    await _editSelected();
                  },
                  onToggleCollapse: state.toggleCollapse,
                  onReparent: (dragged, target) =>
                      state.moveNode(dragged, target),
                  onFreePosition: (id, pos) =>
                      state.setNodePosition(id, pos.dx, pos.dy),
                ),
              ),
            ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.onAddChild,
    required this.onAddSibling,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onAddChild;
  final VoidCallback onAddSibling;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'child',
          tooltip: 'Add child (Tab)',
          onPressed: onAddChild,
          child: const Icon(Icons.subdirectory_arrow_right),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'sibling',
          tooltip: 'Add sibling (Enter)',
          onPressed: onAddSibling,
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'edit',
          tooltip: 'Edit node',
          onPressed: onEdit,
          child: const Icon(Icons.edit),
        ),
        const SizedBox(width: 8),
        FloatingActionButton.small(
          heroTag: 'delete',
          tooltip: 'Delete node (Del)',
          onPressed: onDelete,
          child: const Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}

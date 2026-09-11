import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import '../generated/mindmap.pbgrpc.dart';
import '../services/mindmap_client.dart';

/// Central store of UI state. Every mutating RPC returns the whole document, so
/// we simply replace [current] with the server's response and notify — the tree
/// on screen is always exactly what the backend persisted.
class AppState extends ChangeNotifier {
  AppState(this._client);

  final MindMapClient _client;

  List<MapSummary> maps = [];
  MindMap? current;
  String? selectedNodeId;
  String? lastError;
  bool loading = false;

  MindMapServiceClient get _stub => _client.stub;

  Node? get selectedNode {
    final m = current;
    final id = selectedNodeId;
    if (m == null || id == null) return null;
    return _findAnywhere(m, id);
  }

  Node? _findNode(Node n, String id) {
    if (n.id == id) return n;
    for (final c in n.children) {
      final found = _findNode(c, id);
      if (found != null) return found;
    }
    return null;
  }

  /// Searches the root tree and every unattached subtree.
  Node? _findAnywhere(MindMap m, String id) {
    final inRoot = _findNode(m.root, id);
    if (inRoot != null) return inRoot;
    for (final u in m.unattached) {
      final found = _findNode(u, id);
      if (found != null) return found;
    }
    return null;
  }

  Future<T?> _guard<T>(Future<T> Function() op) async {
    lastError = null;
    try {
      return await op();
    } on GrpcError catch (e) {
      lastError = e.message ?? e.toString();
    } catch (e) {
      lastError = e.toString();
    } finally {
      notifyListeners();
    }
    return null;
  }

  Future<void> refreshList() async {
    await _guard(() async {
      final resp = await _stub.listMaps(ListMapsRequest());
      maps = resp.maps;
    });
  }

  Future<MindMap?> newMap(String title) async {
    return _guard(() async {
      final m = await _stub.createMap(CreateMapRequest(title: title));
      current = m;
      selectedNodeId = m.root.id;
      await refreshList();
      return m;
    });
  }

  /// Create a new map from a natural-language prompt using the server-side
  /// LLM. Returns the created map or null on error.
  Future<MindMap?> createFromPrompt(String prompt, {String? titleHint, int? maxNodes}) async {
    return _guard(() async {
      final req = CreateFromPromptRequest(
        prompt: prompt,
        titleHint: titleHint ?? '',
        maxNodes: maxNodes ?? 200,
      );
      final m = await _stub.createMapFromPrompt(req);
      current = m;
      selectedNodeId = m.root.id;
      await refreshList();
      return m;
    });
  }

  Future<void> openMap(String id) async {
    await _guard(() async {
      final m = await _stub.getMap(GetMapRequest(id: id));
      current = m;
      selectedNodeId = m.root.id;
    });
  }

  Future<void> deleteMap(String id) async {
    await _guard(() async {
      await _stub.deleteMap(DeleteMapRequest(id: id));
      if (current?.id == id) current = null;
      await refreshList();
    });
  }

  void _apply(MindMap m) {
    current = m;
    notifyListeners();
  }

  Future<void> addChild({String? parentId, String text = 'New idea'}) async {
    final m = current;
    if (m == null) return;
    final parent = parentId ?? selectedNodeId ?? m.root.id;
    await _guard(() async {
      final updated = await _stub.addNode(
        AddNodeRequest(mapId: m.id, parentId: parent, text: text),
      );
      // Select the newest child of the parent for a smooth "keep typing" flow.
      final p = _findAnywhere(updated, parent);
      if (p != null && p.children.isNotEmpty) {
        selectedNodeId = p.children.last.id;
      }
      _apply(updated);
    });
  }

  /// Creates a free-floating node that isn't connected anywhere into the
  /// tree. Drag it onto another node (or use [moveNode]) to link it in.
  Future<void> addStandaloneNode({String text = 'New idea'}) async {
    final m = current;
    if (m == null) return;
    await _guard(() async {
      final updated = await _stub.addNode(
        AddNodeRequest(mapId: m.id, text: text, standalone: true),
      );
      if (updated.unattached.isNotEmpty) {
        selectedNodeId = updated.unattached.last.id;
      }
      _apply(updated);
    });
  }

  String? _parentIdOf(Node n, String id) {
    for (final c in n.children) {
      if (c.id == id) return n.id;
      final found = _parentIdOf(c, id);
      if (found != null) return found;
    }
    return null;
  }

  /// Searches the root tree and every unattached subtree; returns null both
  /// when [id] isn't found and when it is itself a top-level unattached node
  /// (which has no parent).
  String? _parentIdOfAnywhere(MindMap m, String id) {
    final inRoot = _parentIdOf(m.root, id);
    if (inRoot != null) return inRoot;
    for (final u in m.unattached) {
      if (u.id == id) return null;
      final found = _parentIdOf(u, id);
      if (found != null) return found;
    }
    return null;
  }

  /// Adds a sibling of the selected node (a child of the selection's parent).
  /// Falls back to a root child when the root itself is selected, and to
  /// another standalone node when a top-level unattached node is selected.
  Future<void> addSibling({String text = 'New idea'}) async {
    final m = current;
    if (m == null) return;
    final sel = selectedNodeId ?? m.root.id;
    if (m.unattached.any((u) => u.id == sel)) {
      await addStandaloneNode(text: text);
      return;
    }
    final parentId =
        sel == m.root.id ? m.root.id : _parentIdOfAnywhere(m, sel);
    await addChild(parentId: parentId ?? m.root.id, text: text);
  }

  Future<void> deleteNode(String id) async {
    final m = current;
    if (m == null) return;
    await _guard(() async {
      final updated =
          await _stub.deleteNode(DeleteNodeRequest(mapId: m.id, nodeId: id));
      if (selectedNodeId == id) selectedNodeId = updated.root.id;
      _apply(updated);
    });
  }

  Future<void> updateNode(
    String id, {
    String? text,
    String? color,
    String? icon,
    bool? collapsed,
  }) async {
    final m = current;
    if (m == null) return;
    final req = UpdateNodeRequest(mapId: m.id, nodeId: id);
    if (text != null) req.text = text;
    if (color != null) req.color = color;
    if (icon != null) req.icon = icon;
    if (collapsed != null) req.collapsed = collapsed;
    await _guard(() async => _apply(await _stub.updateNode(req)));
  }

  Future<void> toggleCollapse(String id) async {
    final m = current;
    final node = m == null ? null : _findAnywhere(m, id);
    if (node == null) return;
    await updateNode(id, collapsed: !node.collapsed);
  }

  /// Reparents a node under [newParentId] -- this is also how a standalone
  /// node gets linked (or later re-linked, by calling this again with a
  /// different target) into the tree.
  Future<void> moveNode(String nodeId, String newParentId) async {
    final m = current;
    if (m == null) return;
    await _guard(() async {
      final updated = await _stub.moveNode(MoveNodeRequest(
        mapId: m.id,
        nodeId: nodeId,
        newParentId: newParentId,
        index: -1,
      ));
      _apply(updated);
    });
  }

  /// Detaches a node (with its subtree) back into a free-floating,
  /// unattached node.
  Future<void> detachNode(String nodeId) async {
    final m = current;
    if (m == null) return;
    await _guard(() async {
      final updated = await _stub.moveNode(MoveNodeRequest(
        mapId: m.id,
        nodeId: nodeId,
        makeStandalone: true,
      ));
      _apply(updated);
    });
  }

  /// Pins a node to a free position (canvas coordinates). Persisted via
  /// UpdateNode's position field.
  Future<void> setNodePosition(String id, double x, double y) async {
    final m = current;
    if (m == null) return;
    final req = UpdateNodeRequest(mapId: m.id, nodeId: id)
      ..position = (Position()
        ..x = x
        ..y = y);
    await _guard(() async => _apply(await _stub.updateNode(req)));
  }

  /// Clears every node's free position, returning the map to auto-layout.
  Future<void> resetLayout() async {
    final m = current;
    if (m == null) return;
    await _guard(() async =>
        _apply(await _stub.resetLayout(ResetLayoutRequest(mapId: m.id))));
  }

  Future<void> undo() async {
    final m = current;
    if (m == null) return;
    await _guard(() async => _apply(await _stub.undo(UndoRequest(mapId: m.id))));
  }

  Future<void> redo() async {
    final m = current;
    if (m == null) return;
    await _guard(() async => _apply(await _stub.redo(RedoRequest(mapId: m.id))));
  }

  void select(String id) {
    selectedNodeId = id;
    notifyListeners();
  }
}

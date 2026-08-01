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
    return _findNode(m.root, id);
  }

  Node? _findNode(Node n, String id) {
    if (n.id == id) return n;
    for (final c in n.children) {
      final found = _findNode(c, id);
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
      final p = _findNode(updated.root, parent);
      if (p != null && p.children.isNotEmpty) {
        selectedNodeId = p.children.last.id;
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

  /// Adds a sibling of the selected node (a child of the selection's parent).
  /// Falls back to a root child when the root itself is selected.
  Future<void> addSibling({String text = 'New idea'}) async {
    final m = current;
    if (m == null) return;
    final sel = selectedNodeId ?? m.root.id;
    final parentId = sel == m.root.id ? m.root.id : _parentIdOf(m.root, sel);
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
    final node = current == null ? null : _findNode(current!.root, id);
    if (node == null) return;
    await updateNode(id, collapsed: !node.collapsed);
  }

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

// End-to-end check of the Dart gRPC client against a running Go server.
// Usage: dart run tool/e2e.dart [port]
import 'dart:io';

import 'package:mindmap/generated/mindmap.pbgrpc.dart';
import 'package:mindmap/services/mindmap_client.dart';

void expect(bool cond, String msg) {
  if (!cond) {
    stderr.writeln('FAIL: $msg');
    exit(1);
  }
  stdout.writeln('ok - $msg');
}

Future<void> main(List<String> args) async {
  final port = args.isEmpty ? 50051 : int.parse(args.first);
  final client = MindMapClient(port: port);
  final stub = client.stub;

  final map = await stub.createMap(CreateMapRequest(title: 'E2E'));
  expect(map.id.isNotEmpty, 'createMap returns id');
  expect(map.root.text == 'E2E', 'root text seeded from title');

  var m = await stub.addNode(
      AddNodeRequest(mapId: map.id, parentId: map.root.id, text: 'A'));
  expect(m.root.children.length == 1, 'addNode adds one child');
  final aId = m.root.children.first.id;

  m = await stub.addNode(AddNodeRequest(mapId: map.id, parentId: aId, text: 'B'));
  final bId = m.root.children.first.children.first.id;
  expect(m.root.children.first.children.length == 1, 'nested child under A');

  // Move B to be a direct child of root.
  m = await stub.moveNode(MoveNodeRequest(
      mapId: map.id, nodeId: bId, newParentId: map.root.id, index: -1));
  expect(m.root.children.length == 2, 'moveNode reparents B under root');
  expect(m.root.children.first.children.isEmpty, 'A has no children after move');

  // Update B's text + color.
  final upd = UpdateNodeRequest(mapId: map.id, nodeId: bId)
    ..text = 'B-renamed'
    ..color = '#E24A6A';
  m = await stub.updateNode(upd);
  final b = m.root.children.firstWhere((n) => n.id == bId);
  expect(b.text == 'B-renamed' && b.color == '#E24A6A', 'updateNode applies fields');

  // Undo the update, then redo it.
  m = await stub.undo(UndoRequest(mapId: map.id));
  final bAfterUndo = m.root.children.firstWhere((n) => n.id == bId);
  expect(bAfterUndo.text != 'B-renamed', 'undo reverts the rename');
  m = await stub.redo(RedoRequest(mapId: map.id));
  final bAfterRedo = m.root.children.firstWhere((n) => n.id == bId);
  expect(bAfterRedo.text == 'B-renamed', 'redo restores the rename');

  // Pin B to a free position, confirm it persists, then reset layout.
  final pin = UpdateNodeRequest(mapId: map.id, nodeId: bId)
    ..position = (Position()
      ..x = 321
      ..y = 654);
  m = await stub.updateNode(pin);
  var bPinned = m.root.children.firstWhere((n) => n.id == bId);
  expect(bPinned.hasPosition() && bPinned.position.x == 321 && bPinned.position.y == 654,
      'setNodePosition pins a free position');

  m = await stub.resetLayout(ResetLayoutRequest(mapId: map.id));
  bPinned = m.root.children.firstWhere((n) => n.id == bId);
  expect(!bPinned.hasPosition(), 'resetLayout clears the pinned position');

  // Delete A (which now has no children).
  m = await stub.deleteNode(DeleteNodeRequest(mapId: map.id, nodeId: aId));
  expect(m.root.children.every((n) => n.id != aId), 'deleteNode removes A');

  // Persistence: getMap returns the same document.
  final reloaded = await stub.getMap(GetMapRequest(id: map.id));
  expect(reloaded.root.children.length == 1, 'getMap reflects persisted state');

  final list = await stub.listMaps(ListMapsRequest());
  expect(list.maps.any((s) => s.id == map.id), 'listMaps includes our map');

  await stub.deleteMap(DeleteMapRequest(id: map.id));
  await client.shutdown();
  stdout.writeln('\nALL E2E CHECKS PASSED');
}

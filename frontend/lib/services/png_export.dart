import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Captures the widget behind [boundaryKey] as a PNG and prompts the user for a
/// save location. Returns the written path, or null if cancelled/unavailable.
Future<String?> exportBoundaryToPng(GlobalKey boundaryKey, String suggestedName) async {
  final boundary =
      boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return null;

  final image = await boundary.toImage(pixelRatio: 2.5);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  if (data == null) return null;
  final bytes = data.buffer.asUint8List();

  final location = await getSaveLocation(
    acceptedTypeGroups: const [
      XTypeGroup(label: 'PNG image', extensions: ['png']),
    ],
    suggestedName: suggestedName,
  );
  if (location == null) return null;

  final file = XFile.fromData(bytes, mimeType: 'image/png', name: suggestedName);
  await file.saveTo(location.path);
  return location.path;
}

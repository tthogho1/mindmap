import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Held for the app's lifetime so the server's stdin pipe stays open; the
/// server shuts itself down when that pipe closes.
// ignore: unused_element
Process? _server;

/// Starts the Go core bundled next to the app executable (the packaged Windows
/// build ships `mindmap-server.exe` there), so the app is a single
/// double-click with no console window.
///
/// Does nothing when a server is already listening — e.g. one started by
/// `scripts/dev.sh` or by hand — or when no bundled binary is found.
Future<void> ensureServerRunning({required String host, required int port}) async {
  if (await _isListening(host, port)) return;

  final dir = File(Platform.resolvedExecutable).parent.path;
  final name = Platform.isWindows ? 'mindmap-server.exe' : 'mindmap-server';
  final exe = File('$dir${Platform.pathSeparator}$name');
  if (!exe.existsSync()) return;

  // -exit-with-parent: the server exits when our end of its stdin closes,
  // which happens whenever this app exits — even on a crash — so it is never
  // left running invisibly in the background.
  final process = await Process.start(
    exe.path,
    ['-addr', '$host:$port', '-exit-with-parent'],
  );
  _server = process;

  // Drain output so a full pipe can never block the server's logging.
  process.stdout.drain<void>();
  process.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) => debugPrint('[server] $line'));

  var exited = false;
  unawaited(process.exitCode.then((_) => exited = true));

  final deadline = DateTime.now().add(const Duration(seconds: 10));
  while (!exited && DateTime.now().isBefore(deadline)) {
    if (await _isListening(host, port)) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<bool> _isListening(String host, int port) async {
  try {
    final socket = await Socket.connect(
      host,
      port,
      timeout: const Duration(milliseconds: 300),
    );
    socket.destroy();
    return true;
  } on SocketException {
    return false;
  }
}

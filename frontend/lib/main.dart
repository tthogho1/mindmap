import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/mindmap_client.dart';
import 'services/server_launcher.dart';
import 'state/app_state.dart';

Future<void> main() async {
  final client = MindMapClient();
  await ensureServerRunning(host: client.host, port: client.port);
  runApp(MindMapApp(client: client));
}

class MindMapApp extends StatelessWidget {
  const MindMapApp({super.key, required this.client});

  final MindMapClient client;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(client),
      child: MaterialApp(
        title: 'Mind Map',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

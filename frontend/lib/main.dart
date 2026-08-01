import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/mindmap_client.dart';
import 'state/app_state.dart';

void main() {
  final client = MindMapClient();
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

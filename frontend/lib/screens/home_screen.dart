import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().refreshList();
    });
  }

  Future<void> _openEditor() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );
    if (mounted) context.read<AppState>().refreshList();
  }

  Future<void> _newMap() async {
    final controller = TextEditingController(text: 'Untitled map');
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New mind map'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (title == null || !mounted) return;
    final state = context.read<AppState>();
    final created = await state.newMap(title.trim().isEmpty ? 'Untitled' : title.trim());
    if (created != null && mounted) _openEditor();
  }

  String _formatTime(int millis) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis);
    final d = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final t = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Maps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.refreshList,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newMap,
        icon: const Icon(Icons.add),
        label: const Text('New map'),
      ),
      body: state.maps.isEmpty
          ? const Center(
              child: Text('No maps yet. Create one to get started.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.maps.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final m = state.maps[i];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.account_tree),
                    title: Text(m.title),
                    subtitle: Text('Updated ${_formatTime(m.updatedAt.toInt())}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(m.id, m.title),
                    ),
                    onTap: () async {
                      await state.openMap(m.id);
                      if (state.current != null && mounted) _openEditor();
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _confirmDelete(String id, String title) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete "$title"?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) context.read<AppState>().deleteMap(id);
  }
}

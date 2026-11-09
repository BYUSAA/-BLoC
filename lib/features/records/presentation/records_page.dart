import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/preferences/preferences_cubit.dart';
import '../../auth/presentation/auth_cubit.dart';
import '../data/records_repository_impl.dart';
import '../domain/record.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key, required this.repository});
  final RecordsRepositoryImpl repository;

  Future<void> _edit(BuildContext context, [Record? record]) async {
    final title = TextEditingController(text: record?.title ?? '');
    final description = TextEditingController(text: record?.description ?? '');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
      title: Text(record == null ? 'New record' : 'Edit record'),
      content: Form(key: formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: title, autofocus: true, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null),
        TextFormField(controller: description, decoration: const InputDecoration(labelText: 'Description')),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () { if (formKey.currentState!.validate()) Navigator.pop(dialogContext, true); }, child: const Text('Save'))],
    ));
    if (result == true && context.mounted) {
      try {
        if (record == null) await repository.create(title: title.text, description: description.text);
        else await repository.update(record, title: title.text, description: description.text);
      } catch (error) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $error')));
      }
    }
    title.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferencesCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('My workspace'), actions: [
        IconButton(tooltip: 'Settings', icon: const Icon(Icons.settings_outlined), onPressed: () => showModalBottomSheet<void>(context: context, builder: (_) => const _PreferencesSheet())),
        IconButton(tooltip: 'Sign out', icon: const Icon(Icons.logout), onPressed: () => context.read<AuthCubit>().signOut()),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () => _edit(context), icon: const Icon(Icons.add), label: const Text('Add record')),
      body: StreamBuilder<List<Record>>(
        stream: repository.watchRecords(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Unable to load records: ${snapshot.error}')));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final records = snapshot.data ?? [];
          if (records.isEmpty) return const Center(child: Text('No records yet. Add your first one.'));
          return ListView.separated(
            padding: EdgeInsets.all(prefs.compactLayout ? 12 : 20),
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(child: ListTile(
                title: Text(record.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(record.description.isEmpty ? 'No description' : record.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => _edit(context, record),
                trailing: IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Delete record', onPressed: () async {
                  final confirm = await showDialog<bool>(context: context, builder: (dialogContext) => AlertDialog(
                    title: const Text('Delete record?'),
                    content: Text('Delete “${record.title}”?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
                    ],
                  ));
                  if (confirm == true) {
                    try { await repository.delete(record.id); }
                    catch (error) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not delete: $error'))); }
                  }
                }),
              ));
            },
          );
        },
      ),
    );
  }
}

class _PreferencesSheet extends StatelessWidget {
  const _PreferencesSheet();
  @override
  Widget build(BuildContext context) => SafeArea(child: Padding(
    padding: const EdgeInsets.all(20),
    child: BlocBuilder<PreferencesCubit, PreferencesState>(builder: (context, state) => Column(mainAxisSize: MainAxisSize.min, children: [
      SwitchListTile(title: const Text('Dark theme'), value: state.darkMode, onChanged: context.read<PreferencesCubit>().setDarkMode),
      SwitchListTile(title: const Text('Notifications enabled'), value: state.notificationsEnabled, onChanged: context.read<PreferencesCubit>().setNotifications),
      SwitchListTile(title: const Text('Compact layout'), value: state.compactLayout, onChanged: context.read<PreferencesCubit>().setCompactLayout),
    ])),
  ));
}

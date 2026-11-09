import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/preferences/preferences_cubit.dart';
import '../../auth/presentation/auth_cubit.dart';
import '../data/records_repository_impl.dart';
import '../domain/record.dart';
import 'records_cubit.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key, required this.repository});

  final RecordsRepositoryImpl repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecordsCubit(repository)..watch(),
      child: const _RecordsView(),
    );
  }
}

class _RecordsView extends StatelessWidget {
  const _RecordsView();

  Future<void> _edit(BuildContext context, [Record? record]) async {
    final titleController = TextEditingController(text: record?.title ?? '');
    final descriptionController =
        TextEditingController(text: record?.description ?? '');
    final formKey = GlobalKey<FormState>();

    try {
      final shouldSave = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(record == null ? 'New record' : 'Edit record'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  maxLength: RecordsRepositoryImpl.maxTitleLength,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) return 'Title is required.';
                    if (title.length > RecordsRepositoryImpl.maxTitleLength) {
                      return 'Title is too long.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLength: RecordsRepositoryImpl.maxDescriptionLength,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if ((value?.length ?? 0) >
                        RecordsRepositoryImpl.maxDescriptionLength) {
                      return 'Description is too long.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.pop(dialogContext, true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (shouldSave != true || !context.mounted) return;

      final cubit = context.read<RecordsCubit>();
      if (record == null) {
        await cubit.create(
          title: titleController.text,
          description: descriptionController.text,
        );
      } else {
        await cubit.update(
          record,
          title: titleController.text,
          description: descriptionController.text,
        );
      }
    } finally {
      titleController.dispose();
      descriptionController.dispose();
    }
  }

  Future<void> _delete(BuildContext context, Record record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete record?'),
        content: Text('Delete “${record.title}”? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<RecordsCubit>().delete(record.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesCubit>().state;

    return BlocListener<RecordsCubit, RecordsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage &&
          current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
        context.read<RecordsCubit>().clearError();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My workspace'),
          actions: [
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                builder: (_) => const _PreferencesSheet(),
              ),
            ),
            IconButton(
              tooltip: 'Sign out',
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthCubit>().signOut(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _edit(context),
          icon: const Icon(Icons.add),
          label: const Text('Add record'),
        ),
        body: BlocBuilder<RecordsCubit, RecordsState>(
          builder: (context, state) {
            if (state.status == RecordsStatus.initial ||
                state.status == RecordsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == RecordsStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined, size: 44),
                      const SizedBox(height: 12),
                      const Text('Your records could not be loaded.'),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: context.read<RecordsCubit>().watch,
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state.records.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox_outlined, size: 52),
                      SizedBox(height: 12),
                      Text(
                        'No records yet. Add your first one.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.all(preferences.compactLayout ? 12 : 20),
              itemCount: state.records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final record = state.records[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    title: Text(
                      record.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      record.description.isEmpty
                          ? 'No description'
                          : record.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _edit(context, record),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete record',
                      onPressed: state.isMutating
                          ? null
                          : () => _delete(context, record),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PreferencesSheet extends StatelessWidget {
  const _PreferencesSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<PreferencesCubit, PreferencesState>(
          builder: (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Dark theme'),
                value: state.darkMode,
                onChanged: context.read<PreferencesCubit>().setDarkMode,
              ),
              SwitchListTile(
                title: const Text('Notifications enabled'),
                value: state.notificationsEnabled,
                onChanged: context.read<PreferencesCubit>().setNotifications,
              ),
              SwitchListTile(
                title: const Text('Compact layout'),
                value: state.compactLayout,
                onChanged: context.read<PreferencesCubit>().setCompactLayout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

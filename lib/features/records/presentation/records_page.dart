import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/preferences/preferences_cubit.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_loading.dart';
import '../../auth/presentation/auth_cubit.dart';
import '../domain/record.dart';
import '../domain/records_repository.dart';
import 'records_cubit.dart';
import 'widgets/records_empty_state.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key, required this.repository});

  final RecordsRepository repository;

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
                  maxLength: RecordsRepository.maxTitleLength,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: Validators.recordTitle,
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLength: RecordsRepository.maxDescriptionLength,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: Validators.recordDescription,
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

    return MultiBlocListener(
      listeners: [
        BlocListener<RecordsCubit, RecordsState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
            context.read<RecordsCubit>().clearError();
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.error != current.error && current.error != null,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error!)),
            );
            context.read<AuthCubit>().clearFeedback();
          },
        ),
      ],
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
        floatingActionButton: BlocBuilder<RecordsCubit, RecordsState>(
          builder: (context, state) => FloatingActionButton.extended(
            onPressed: state.isMutating ? null : () => _edit(context),
            icon: const Icon(Icons.add),
            label: const Text('Add record'),
          ),
        ),
        body: BlocBuilder<RecordsCubit, RecordsState>(
          builder: (context, state) {
            if (state.status == RecordsStatus.initial ||
                state.status == RecordsStatus.loading) {
              return const AppLoading(label: 'Loading records');
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
                      const Text(
                        'Your records could not be loaded.',
                        textAlign: TextAlign.center,
                      ),
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

            return Column(
              children: [
                if (state.isMutating) const LinearProgressIndicator(),
                Expanded(
                  child: state.records.isEmpty
                      ? const RecordsEmptyState()
                      : ListView.separated(
                          padding: EdgeInsets.all(
                            preferences.compactLayout ? 12 : 20,
                          ),
                          itemCount: state.records.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
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
                                onTap: state.isMutating
                                    ? null
                                    : () => _edit(context, record),
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
                        ),
                ),
              ],
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
                title: const Text('Notifications preference'),
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

import 'dart:async';

import 'package:bloc_assignment_app/core/preferences/preferences_cubit.dart';
import 'package:bloc_assignment_app/features/records/domain/record.dart';
import 'package:bloc_assignment_app/features/records/domain/records_repository.dart';
import 'package:bloc_assignment_app/features/records/presentation/records_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRecordsRepository implements RecordsRepository {
  final StreamController<List<Record>> _controller =
      StreamController<List<Record>>.broadcast();

  @override
  Stream<List<Record>> watchRecords() => _controller.stream;

  @override
  Future<void> create({
    required String title,
    required String description,
  }) async {}

  @override
  Future<void> update(
    Record record, {
    required String title,
    required String description,
  }) async {}

  @override
  Future<void> delete(String id) async {}

  Future<void> dispose() => _controller.close();
}

void main() {
  testWidgets('workspace shows the empty state after records load', (
    tester,
  ) async {
    final repository = _FakeRecordsRepository();
    final preferences = PreferencesCubit();

    await tester.pumpWidget(
      BlocProvider.value(
        value: preferences,
        child: MaterialApp(
          home: RecordsPage(repository: repository),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    repository._controller.add(const []);
    await tester.pumpAndSettle();

    expect(find.text('My workspace'), findsOneWidget);
    expect(find.text('No records yet. Add your first one.'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('New record'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await preferences.close();
    await repository.dispose();
  });
}

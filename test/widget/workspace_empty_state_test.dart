import 'dart:async';

import 'package:bloc_assignment_app/core/preferences/preferences_cubit.dart';
import 'package:bloc_assignment_app/features/auth/domain/auth_repository.dart';
import 'package:bloc_assignment_app/features/auth/presentation/auth_cubit.dart';
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

class _FakeAuthRepository implements AuthRepository {
  @override
  bool get hasActiveSession => true;

  @override
  bool get emailVerificationRequired => false;

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> register(String email, String password) async {}

  @override
  Future<bool> signInWithGoogle() async => true;

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('workspace shows empty state and create form after loading', (
    tester,
  ) async {
    final repository = _FakeRecordsRepository();
    final preferences = PreferencesCubit();
    final authCubit = AuthCubit(_FakeAuthRepository());
    addTearDown(() async {
      await authCubit.close();
      await preferences.close();
      await repository.dispose();
    });

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: preferences),
          BlocProvider.value(value: authCubit),
        ],
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
  });
}

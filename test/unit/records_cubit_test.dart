import 'dart:async';

import 'package:bloc_assignment_app/features/records/domain/record.dart';
import 'package:bloc_assignment_app/features/records/domain/records_repository.dart';
import 'package:bloc_assignment_app/features/records/presentation/records_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRecordsRepository implements RecordsRepository {
  final StreamController<List<Record>> _controller =
      StreamController<List<Record>>.broadcast();
  final List<Record> records = [];
  bool shouldFail = false;

  @override
  Stream<List<Record>> watchRecords() => _controller.stream;

  void publish() {
    _controller.add(List<Record>.unmodifiable(records));
  }

  @override
  Future<void> create({
    required String title,
    required String description,
  }) async {
    if (shouldFail) throw StateError('simulated write failure');
    records.add(
      Record(
        id: 'record-${records.length + 1}',
        title: title,
        description: description,
        ownerId: 'test-user',
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );
    publish();
  }

  @override
  Future<void> update(
    Record record, {
    required String title,
    required String description,
  }) async {
    if (shouldFail) throw StateError('simulated write failure');
    final index = records.indexWhere((item) => item.id == record.id);
    if (index < 0) throw StateError('record not found');
    records[index] = Record(
      id: record.id,
      title: title,
      description: description,
      ownerId: record.ownerId,
      updatedAt: DateTime.utc(2026, 1, 2),
    );
    publish();
  }

  @override
  Future<void> delete(String id) async {
    if (shouldFail) throw StateError('simulated write failure');
    records.removeWhere((record) => record.id == id);
    publish();
  }

  Future<void> dispose() => _controller.close();
}

void main() {
  late _FakeRecordsRepository repository;
  late RecordsCubit cubit;

  setUp(() {
    repository = _FakeRecordsRepository();
    cubit = RecordsCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('loads records from the repository stream', () async {
    final loaded = expectLater(
      cubit.stream,
      emitsThrough(
        isA<RecordsState>()
            .having((state) => state.status, 'status', RecordsStatus.loaded)
            .having((state) => state.records.length, 'record count', 1),
      ),
    );

    cubit.watch();
    await Future<void>.delayed(Duration.zero);
    repository.records.add(
      Record(
        id: 'record-1',
        title: 'First record',
        description: 'A test record',
        ownerId: 'test-user',
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );
    repository.publish();

    await loaded;
  });

  test('create delegates to the repository', () async {
    await cubit.create(title: 'New item', description: 'Details');

    expect(repository.records, hasLength(1));
    expect(repository.records.single.title, 'New item');
    expect(cubit.state.isMutating, isFalse);
  });

  test('failed mutations expose a safe error state', () async {
    repository.shouldFail = true;

    await cubit.create(title: 'New item', description: '');

    expect(cubit.state.isMutating, isFalse);
    expect(cubit.state.errorMessage, isNotNull);
    expect(cubit.state.errorMessage, isNot(contains('simulated')));
  });
}

import 'record.dart';

/// Contract for reading and mutating the signed-in user's records.
abstract interface class RecordsRepository {
  Stream<List<Record>> watchRecords();

  Future<void> create({
    required String title,
    required String description,
  });

  Future<void> update(
    Record record, {
    required String title,
    required String description,
  });

  Future<void> delete(String id);
}

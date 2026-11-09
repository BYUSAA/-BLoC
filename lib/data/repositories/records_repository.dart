import '../../features/records/domain/record.dart';

abstract interface class RecordsRepository {
  Stream<List<Record>> watchRecords();
  Future<void> create({required String title, required String description});
  Future<void> update(Record record, {required String title, required String description});
  Future<void> delete(String id);
}

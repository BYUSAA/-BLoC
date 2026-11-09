import 'package:bloc_assignment_app/features/records/domain/record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('records with the same values compare equally', () {
    final updatedAt = DateTime.utc(2026, 11, 9);
    final first = Record(
      id: 'record-1',
      title: 'A record',
      description: 'Details',
      ownerId: 'user-1',
      updatedAt: updatedAt,
    );
    final second = Record(
      id: 'record-1',
      title: 'A record',
      description: 'Details',
      ownerId: 'user-1',
      updatedAt: updatedAt,
    );

    expect(first, equals(second));
  });

  test('records with different owners are not equal', () {
    final updatedAt = DateTime.utc(2026, 11, 9);
    final first = Record(
      id: 'record-1',
      title: 'A record',
      description: 'Details',
      ownerId: 'user-1',
      updatedAt: updatedAt,
    );
    final second = Record(
      id: 'record-1',
      title: 'A record',
      description: 'Details',
      ownerId: 'user-2',
      updatedAt: updatedAt,
    );

    expect(first, isNot(equals(second)));
  });
}

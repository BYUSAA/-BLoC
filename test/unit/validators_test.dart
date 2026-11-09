import 'package:bloc_assignment_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email validation', () {
    test('accepts a valid email address', () {
      expect(Validators.email('student@example.com'), isNull);
    });

    test('trims surrounding whitespace', () {
      expect(Validators.email('  student@example.com  '), isNull);
    });

    test('rejects an empty email address', () {
      expect(Validators.email('  '), 'Email is required.');
    });

    test('rejects malformed email addresses', () {
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('student@'), isNotNull);
    });
  });

  group('password validation', () {
    test('accepts a password with at least six characters', () {
      expect(Validators.password('secure1'), isNull);
    });

    test('rejects a missing or short password', () {
      expect(Validators.password(null), 'Password is required.');
      expect(Validators.password('12345'), 'Use at least 6 characters.');
    });
  });

  group('record validation', () {
    test('requires a non-empty title', () {
      expect(Validators.recordTitle('  '), 'Title is required.');
    });

    test('rejects titles longer than the configured limit', () {
      expect(
        Validators.recordTitle(List<String>.filled(101, 'a').join()),
        isNotNull,
      );
    });

    test('accepts a valid title and description', () {
      expect(Validators.recordTitle('A record'), isNull);
      expect(Validators.recordDescription('Details'), isNull);
      expect(Validators.recordDescription(null), isNull);
    });

    test('rejects descriptions longer than the configured limit', () {
      expect(
        Validators.recordDescription(List<String>.filled(1001, 'a').join()),
        isNotNull,
      );
    });
  });
}

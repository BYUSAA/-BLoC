import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_assignment_app/core/preferences/preferences_cubit.dart';

void main() {
  test('default preferences are safe defaults', () {
    const state = PreferencesState();
    expect(state.darkMode, isFalse);
    expect(state.notificationsEnabled, isTrue);
    expect(state.compactLayout, isFalse);
  });
  test('copyWith updates only selected value', () {
    const state = PreferencesState();
    final updated = state.copyWith(darkMode: true);
    expect(updated.darkMode, isTrue);
    expect(updated.notificationsEnabled, isTrue);
    expect(updated.compactLayout, isFalse);
  });
  test('copyWith supports multiple preference updates', () {
    const state = PreferencesState();
    final updated = state.copyWith(compactLayout: true, notificationsEnabled: false);
    expect(updated.compactLayout, isTrue);
    expect(updated.notificationsEnabled, isFalse);
    expect(updated.darkMode, isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_assignment_app/core/preferences/preferences_cubit.dart';

void main() {
  test('default preferences are safe defaults', () {
    const state = PreferencesState();
    expect(state.darkMode, isFalse);
    expect(state.notificationsEnabled, isTrue);
    expect(state.compactLayout, isFalse);
  });
  test('copyWith changes only the selected preference', () {
    const state = PreferencesState();
    final changed = state.copyWith(darkMode: true);
    expect(changed.darkMode, isTrue);
    expect(changed.notificationsEnabled, isTrue);
    expect(changed.compactLayout, isFalse);
  });
  test('copyWith can update compact layout and notification preference', () {
    const state = PreferencesState();
    final changed = state.copyWith(compactLayout: true, notificationsEnabled: false);
    expect(changed.compactLayout, isTrue);
    expect(changed.notificationsEnabled, isFalse);
    expect(changed.darkMode, isFalse);
  });
}

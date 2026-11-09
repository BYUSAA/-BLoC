import 'package:bloc_assignment_app/core/preferences/preferences_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('default preferences are safe defaults', () {
    const state = PreferencesState();

    expect(state.darkMode, isFalse);
    expect(state.notificationsEnabled, isTrue);
    expect(state.compactLayout, isFalse);
  });

  test('copyWith updates only the selected value', () {
    const state = PreferencesState();

    final updated = state.copyWith(darkMode: true);

    expect(updated.darkMode, isTrue);
    expect(updated.notificationsEnabled, isTrue);
    expect(updated.compactLayout, isFalse);
  });

  test('copyWith supports multiple preference updates', () {
    const state = PreferencesState();

    final updated = state.copyWith(
      compactLayout: true,
      notificationsEnabled: false,
    );

    expect(updated.compactLayout, isTrue);
    expect(updated.notificationsEnabled, isFalse);
    expect(updated.darkMode, isFalse);
  });

  test('equivalent preference states compare equally', () {
    const first = PreferencesState(darkMode: true, compactLayout: true);
    const second = PreferencesState(darkMode: true, compactLayout: true);

    expect(first, equals(second));
  });

  test('loads saved preferences from local storage', () async {
    SharedPreferences.setMockInitialValues({
      'darkMode': true,
      'notificationsEnabled': false,
      'compactLayout': true,
    });
    final cubit = PreferencesCubit();

    await cubit.load();

    expect(cubit.state.darkMode, isTrue);
    expect(cubit.state.notificationsEnabled, isFalse);
    expect(cubit.state.compactLayout, isTrue);
    await cubit.close();
  });

  test('persists changes to local storage', () async {
    final cubit = PreferencesCubit();

    await cubit.setDarkMode(true);
    await cubit.setNotifications(false);
    await cubit.setCompactLayout(true);

    final storage = await SharedPreferences.getInstance();
    expect(storage.getBool('darkMode'), isTrue);
    expect(storage.getBool('notificationsEnabled'), isFalse);
    expect(storage.getBool('compactLayout'), isTrue);
    await cubit.close();
  });
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesState extends Equatable {
  const PreferencesState({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.compactLayout = false,
  });

  final bool darkMode;
  final bool notificationsEnabled;
  final bool compactLayout;

  PreferencesState copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? compactLayout,
  }) {
    return PreferencesState(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      compactLayout: compactLayout ?? this.compactLayout,
    );
  }

  @override
  List<Object?> get props => [
        darkMode,
        notificationsEnabled,
        compactLayout,
      ];
}

/// Persists user-facing preferences independently of authentication.
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(const PreferencesState());

  static const _darkModeKey = 'darkMode';
  static const _notificationsKey = 'notificationsEnabled';
  static const _compactLayoutKey = 'compactLayout';

  Future<void> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (isClosed) return;
      emit(
        PreferencesState(
          darkMode: preferences.getBool(_darkModeKey) ?? false,
          notificationsEnabled:
              preferences.getBool(_notificationsKey) ?? true,
          compactLayout: preferences.getBool(_compactLayoutKey) ?? false,
        ),
      );
    } catch (_) {
      // Defaults remain usable if local storage is temporarily unavailable.
    }
  }

  Future<void> setDarkMode(bool value) async {
    await _persist(_darkModeKey, value);
    emit(state.copyWith(darkMode: value));
  }

  Future<void> setNotifications(bool value) async {
    await _persist(_notificationsKey, value);
    emit(state.copyWith(notificationsEnabled: value));
  }

  Future<void> setCompactLayout(bool value) async {
    await _persist(_compactLayoutKey, value);
    emit(state.copyWith(compactLayout: value));
  }

  Future<void> _persist(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }
}

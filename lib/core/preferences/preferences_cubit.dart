import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PreferencesState {
  const PreferencesState({this.darkMode = false, this.notificationsEnabled = true, this.compactLayout = false});
  final bool darkMode;
  final bool notificationsEnabled;
  final bool compactLayout;
  PreferencesState copyWith({bool? darkMode, bool? notificationsEnabled, bool? compactLayout}) => PreferencesState(
    darkMode: darkMode ?? this.darkMode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    compactLayout: compactLayout ?? this.compactLayout);
}
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(const PreferencesState());
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    emit(PreferencesState(darkMode: prefs.getBool('darkMode') ?? false,
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      compactLayout: prefs.getBool('compactLayout') ?? false));
  }
  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    emit(state.copyWith(darkMode: value));
  }
  Future<void> setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    emit(state.copyWith(notificationsEnabled: value));
  }
  Future<void> setCompactLayout(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('compactLayout', value);
    emit(state.copyWith(compactLayout: value));
  }
}

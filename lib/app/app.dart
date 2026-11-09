import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/preferences/preferences_cubit.dart';
import '../features/auth/presentation/auth_cubit.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/records/domain/records_repository.dart';
import '../features/records/presentation/records_page.dart';

class AssignmentApp extends StatelessWidget {
  const AssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesCubit>().state;

    return MaterialApp(
      title: 'BLoC Assignment',
      debugShowCheckedModeBanner: false,
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.unknown) {
            return const _StartupScreen();
          }

          if (state.status == AuthStatus.authenticated) {
            return RecordsPage(
              repository: context.read<RecordsRepository>(),
            );
          }

          return const SignInPage();
        },
      ),
    );
  }
}

class FirebaseSetupApp extends StatelessWidget {
  const FirebaseSetupApp({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesCubit>().state;

    return MaterialApp(
      title: 'BLoC Assignment Setup',
      debugShowCheckedModeBanner: false,
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase setup required')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.cloud_off_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'The app has launched, but Firebase is not configured.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(error),
                  const SizedBox(height: 16),
                  const Text(
                    'Follow docs/installation.md and supply the Firebase '
                    'Dart-define values. Never commit service-account private keys.',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Semantics(
          label: 'Restoring your session',
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF3157D5),
    brightness: brightness,
  );

  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    appBarTheme: const AppBarTheme(centerTitle: false),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.28),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
  );
}

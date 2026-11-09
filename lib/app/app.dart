import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants/app_constants.dart';
import 'theme/app_theme.dart';
import '../core/preferences/preferences_cubit.dart';
import '../core/widgets/app_loading.dart';
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
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
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
      title: '${AppConstants.appName} setup',
      debugShowCheckedModeBanner: false,
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
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
      body: AppLoading(label: 'Restoring your session'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/preferences/preferences_cubit.dart';
import '../features/auth/presentation/auth_cubit.dart';
import '../features/auth/presentation/sign_in_page.dart';
import '../features/records/data/records_repository_impl.dart';
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
      theme: ThemeData(colorSchemeSeed: const Color(0xFF3157D5), useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF8EA5FF), brightness: Brightness.dark, useMaterial3: true),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => state.status == AuthStatus.authenticated
            ? RecordsPage(repository: context.read<RecordsRepositoryImpl>())
            : const SignInPage(),
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
      themeMode: preferences.darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF3157D5), useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: const Color(0xFF8EA5FF), brightness: Brightness.dark, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase setup required')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.cloud_off_outlined, size: 48),
                const SizedBox(height: 16),
                Text('The app has launched, but Firebase is not configured.', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(error),
                const SizedBox(height: 16),
                const Text('Follow docs/installation.md and supply the Firebase dart-define values. Never commit service-account private keys.'),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

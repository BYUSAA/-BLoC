import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'core/config/firebase_config.dart';
import 'core/preferences/preferences_cubit.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/auth_cubit.dart';
import 'features/records/data/records_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = PreferencesCubit();
  await preferences.load();
  String? firebaseError;
  final options = FirebaseConfig.current;
  if (options == null) {
    firebaseError = 'Firebase has not been configured for this app yet.';
  } else {
    try {
      await Firebase.initializeApp(options: options);
    } catch (error) {
      firebaseError = error.toString();
    }
  }
  runApp(BlocProvider.value(
    value: preferences,
    child: firebaseError == null
        ? MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (_) => AuthRepositoryImpl()),
              RepositoryProvider(create: (_) => RecordsRepositoryImpl()),
            ],
            child: Builder(
              builder: (context) => BlocProvider(
                create: (_) => AuthCubit(context.read<AuthRepositoryImpl>())..restoreSession(),
                child: const AssignmentApp(),
              ),
            ),
          )
        : FirebaseSetupApp(error: firebaseError),
  ));
}

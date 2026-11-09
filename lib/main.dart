import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/app.dart';
import 'core/preferences/preferences_cubit.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/auth_cubit.dart';
import 'features/records/data/records_repository_impl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final preferencesCubit = PreferencesCubit();
  await preferencesCubit.load();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepositoryImpl()),
        RepositoryProvider(create: (_) => RecordsRepositoryImpl()),
      ],
      child: BlocProvider.value(
        value: preferencesCubit,
        child: Builder(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(context.read<AuthRepositoryImpl>())..restoreSession(),
            child: const AssignmentApp(),
          ),
        ),
      ),
    ),
  );
}

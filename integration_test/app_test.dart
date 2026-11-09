import 'package:bloc_assignment_app/app/app.dart';
import 'package:bloc_assignment_app/core/preferences/preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('unconfigured app launches a clear Firebase setup screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => PreferencesCubit(),
        child: const FirebaseSetupApp(
          error: 'Firebase configuration values are missing.',
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Firebase setup required'), findsOneWidget);
    expect(
      find.text('The app has launched, but Firebase is not configured.'),
      findsOneWidget,
    );
    expect(find.textContaining('docs/installation.md'), findsOneWidget);
  });
}

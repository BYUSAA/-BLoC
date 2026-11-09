import 'package:bloc_assignment_app/features/auth/domain/auth_repository.dart';
import 'package:bloc_assignment_app/features/auth/presentation/auth_cubit.dart';
import 'package:bloc_assignment_app/features/auth/presentation/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  String? resetEmail;

  @override
  bool get hasActiveSession => false;

  @override
  bool get emailVerificationRequired => false;

  @override
  Future<void> signIn(String email, String password) async {}

  @override
  Future<void> register(String email, String password) async {}

  @override
  Future<bool> signInWithGoogle() async => false;

  @override
  Future<void> sendPasswordReset(String email) async {
    resetEmail = email;
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  late _FakeAuthRepository repository;
  late AuthCubit authCubit;

  setUp(() {
    repository = _FakeAuthRepository();
    authCubit = AuthCubit(repository);
  });

  tearDown(() async {
    await authCubit.close();
  });

  Future<void> pumpSignInPage(WidgetTester tester) {
    return tester.pumpWidget(
      BlocProvider.value(
        value: authCubit,
        child: const MaterialApp(home: SignInPage()),
      ),
    );
  }

  testWidgets('shows validation errors for an empty sign-in form', (
    tester,
  ) async {
    await pumpSignInPage(tester);

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
  });

  testWidgets('switches between sign-in and registration modes', (
    tester,
  ) async {
    await pumpSignInPage(tester);

    await tester.tap(find.text('New here? Create an account'));
    await tester.pump();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Already registered? Sign in'), findsOneWidget);
  });

  testWidgets('sends a password reset using only a valid email', (
    tester,
  ) async {
    await pumpSignInPage(tester);

    await tester.enterText(
      find.byType(TextFormField).first,
      'student@example.com',
    );
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(repository.resetEmail, 'student@example.com');
    expect(
      find.text('Password reset instructions have been sent to your email.'),
      findsOneWidget,
    );
  });
}

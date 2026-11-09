import 'package:bloc_assignment_app/features/auth/domain/auth_repository.dart';
import 'package:bloc_assignment_app/features/auth/presentation/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  bool activeSession = false;
  bool verificationRequired = false;
  bool googleResult = false;
  bool shouldFail = false;

  @override
  bool get hasActiveSession => activeSession;

  @override
  bool get emailVerificationRequired => verificationRequired;

  @override
  Future<void> signIn(String email, String password) async {
    if (shouldFail) throw StateError('sign-in failed');
    activeSession = true;
  }

  @override
  Future<void> register(String email, String password) async {
    if (shouldFail) throw StateError('registration failed');
  }

  @override
  Future<bool> signInWithGoogle() async {
    if (shouldFail) throw StateError('Google sign-in failed');
    activeSession = googleResult;
    return googleResult;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    if (shouldFail) throw StateError('reset failed');
  }

  @override
  Future<void> signOut() async {
    activeSession = false;
  }
}

void main() {
  late _FakeAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = _FakeAuthRepository();
    cubit = AuthCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('restores an existing authenticated session', () async {
    repository.activeSession = true;

    await cubit.restoreSession();

    expect(cubit.state.status, AuthStatus.authenticated);
  });

  test('does not restore an unverified password session', () async {
    repository
      ..activeSession = true
      ..verificationRequired = true;

    await cubit.restoreSession();

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(repository.activeSession, isFalse);
  });

  test('cancelled Google sign-in remains unauthenticated', () async {
    await cubit.googleSignIn();

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.error, isNull);
  });

  test('successful Google sign-in authenticates the user', () async {
    repository.googleResult = true;

    await cubit.googleSignIn();

    expect(cubit.state.status, AuthStatus.authenticated);
  });

  test('registration displays the email verification instruction', () async {
    await cubit.submit(
      'person@example.com',
      'password123',
      register: true,
    );

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.notice, contains('verification link'));
  });

  test('password reset displays a confirmation notice', () async {
    await cubit.resetPassword('person@example.com');

    expect(cubit.state.notice, contains('reset instructions'));
  });

  test('repository errors become safe user-facing errors', () async {
    repository.shouldFail = true;

    await cubit.submit(
      'person@example.com',
      'password123',
      register: false,
    );

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.error, isNotNull);
    expect(cubit.state.error, isNot(contains('sign-in failed')));
  });
}

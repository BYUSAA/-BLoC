import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/auth_exception.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  bool get hasActiveSession => _auth.currentUser != null;

  @override
  bool get emailVerificationRequired {
    final user = _auth.currentUser;
    if (user == null || user.emailVerified) return false;

    return user.providerData.any(
      (provider) => provider.providerId == 'password',
    );
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      final usesPasswordProvider = user?.providerData.any(
            (provider) => provider.providerId == 'password',
          ) ??
          false;

      if (user != null && usesPasswordProvider && !user.emailVerified) {
        try {
          await user.sendEmailVerification();
        } finally {
          await _clearFirebaseSession();
        }

        throw const AuthException(
          code: 'email-not-verified',
          message:
              'Verify your email using the link we sent before signing in.',
        );
      }
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      try {
        await credential.user?.sendEmailVerification();
      } finally {
        await _clearFirebaseSession();
      }
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  /// Returns false when the user closes the Google account picker.
  @override
  Future<bool> signInWithGoogle() async {
    try {
      final serverClientId =
          const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
      final googleSignIn = GoogleSignIn(
        serverClientId: serverClientId.isEmpty ? null : serverClientId,
      );

      final account = await googleSignIn.signIn();
      if (account == null) return false;

      final authentication = await account.authentication;
      if (authentication.idToken == null &&
          authentication.accessToken == null) {
        throw const AuthException(
          code: 'google-token-missing',
          message:
              'Google did not return a sign-in token. Check the OAuth setup.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Firebase Auth is the source of truth for the active session.
    }

    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseError(error);
    }
  }

  Future<void> _clearFirebaseSession() async {
    try {
      await _auth.signOut();
    } catch (_) {
      // Do not leave password-based registration/sign-in active when
      // verification email delivery fails.
    }
  }

  AuthException _mapFirebaseError(FirebaseAuthException error) {
    final message = switch (error.code) {
      'invalid-email' => 'Enter a valid email address.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Choose a stronger password.',
      'user-not-found' => 'No account was found for this email.',
      'wrong-password' || 'invalid-credential' =>
        'The email or password is incorrect.',
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' =>
        'Too many attempts. Try again after a short break.',
      'network-request-failed' =>
        'Network connection failed. Check your internet connection.',
      'operation-not-allowed' =>
        'This sign-in method is not enabled in Firebase.',
      'account-exists-with-different-credential' =>
        'This email is already registered with another sign-in method.',
      _ => 'Authentication could not be completed. Please try again.',
    };

    return AuthException(
      code: error.code,
      message: message,
      cause: error,
    );
  }
}

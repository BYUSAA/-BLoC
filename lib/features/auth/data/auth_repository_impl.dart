import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl {
  AuthRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;

    final passwordProvider = user?.providerData.any(
          (provider) => provider.providerId == 'password',
        ) ??
        false;

    if (user != null && passwordProvider && !user.emailVerified) {
      await user.sendEmailVerification();
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message:
            'Verify your email using the link we sent before signing in.',
      );
    }
  }

  Future<void> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.sendEmailVerification();
    await _auth.signOut();
  }

  /// Returns false when the user closes the Google account picker.
  Future<bool> signInWithGoogle() async {
    final serverClientId =
        const String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
    final googleSignIn = GoogleSignIn(
      serverClientId: serverClientId.isEmpty ? null : serverClientId,
    );

    final account = await googleSignIn.signIn();
    if (account == null) return false;

    final authentication = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: authentication.accessToken,
      idToken: authentication.idToken,
    );
    await _auth.signInWithCredential(credential);
    return true;
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {
      // Firebase Auth remains the source of truth for the active session.
    }
    await _auth.signOut();
  }
}

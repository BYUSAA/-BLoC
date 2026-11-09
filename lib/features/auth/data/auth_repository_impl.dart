import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl {
  AuthRepositoryImpl({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.sendEmailVerification();
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
    } finally {
      await _auth.signOut();
    }
  }
}

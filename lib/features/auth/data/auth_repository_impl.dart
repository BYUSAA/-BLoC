import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl {
  AuthRepositoryImpl({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authChanges => _auth.authStateChanges();
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }
  Future<void> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    await credential.user?.sendEmailVerification();
  }
  Future<void> signInWithGoogle() async {
    final account = await GoogleSignIn().signIn();
    if (account == null) return;
    final tokens = await account.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: tokens.accessToken, idToken: tokens.idToken);
    await _auth.signInWithCredential(credential);
  }
  Future<void> sendPasswordReset(String email) => _auth.sendPasswordResetEmail(email: email.trim());
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}

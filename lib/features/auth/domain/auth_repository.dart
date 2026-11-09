/// Authentication contract consumed by the presentation layer.
abstract interface class AuthRepository {
  bool get hasActiveSession;
  bool get emailVerificationRequired;

  Future<void> signIn(String email, String password);
  Future<void> register(String email, String password);
  Future<bool> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
}

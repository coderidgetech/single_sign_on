abstract class Authenticator {
  Future<void> signInWithGoogle();
  Future<void> signInWithEmailPassword(String email, String password);
// Define other authentication methods
}

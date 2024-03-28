import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    print('signout');
  }

  Future<String?> getIdToken() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final idTokenResult = await user.getIdToken();
        return idTokenResult;
      }
      return null;
    } catch (e) {
      print('Error getting ID token: $e');
      return null;
    }
  }
}

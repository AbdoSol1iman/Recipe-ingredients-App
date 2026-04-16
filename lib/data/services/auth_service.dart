import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? _tryGetFirebaseAuth();

  final FirebaseAuth? _firebaseAuth;

  static FirebaseAuth? _tryGetFirebaseAuth() {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  bool get isAvailable => _firebaseAuth != null;

  User? get currentUser => _firebaseAuth?.currentUser;

  Stream<User?> authStateChanges() =>
      _firebaseAuth?.authStateChanges() ?? const Stream<User?>.empty();

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    final auth = _firebaseAuth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'not-configured',
        message: 'Firebase is not configured for this build.',
      );
    }
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    final auth = _firebaseAuth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'not-configured',
        message: 'Firebase is not configured for this build.',
      );
    }
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) {
    final auth = _firebaseAuth;
    if (auth == null) {
      throw FirebaseAuthException(
        code: 'not-configured',
        message: 'Firebase is not configured for this build.',
      );
    }
    return auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() {
    final auth = _firebaseAuth;
    if (auth == null) {
      return Future.value();
    }
    return auth.signOut();
  }

  String mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account is disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'not-configured':
        return 'Firebase is unavailable for this run. Make sure Firebase is configured and run on Android/iOS.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}

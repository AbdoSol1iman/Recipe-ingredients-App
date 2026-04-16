import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService) {
    _sub = _authService.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
    _user = _authService.currentUser;
  }

  final AuthService _authService;
  StreamSubscription<User?>? _sub;

  User? _user;
  bool isLoading = false;
  String? errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<bool> signIn({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _authService.mapAuthException(e);
      return false;
    } catch (_) {
      errorMessage = 'Could not sign in. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _authService.mapAuthException(e);
      return false;
    } catch (_) {
      errorMessage = 'Could not create account. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendPasswordReset(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _authService.mapAuthException(e);
      return false;
    } catch (_) {
      errorMessage = 'Could not send reset email. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

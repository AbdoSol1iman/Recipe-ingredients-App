import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/recipe_model.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/sign_up_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/recipe_detail/recipe_detail_screen.dart';
import '../presentation/screens/saved/saved_screen.dart';
import '../presentation/screens/search/search_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';

class AppRouter {
  static final _authRefresh = _AuthRefreshNotifier(_safeAuthStateChanges());

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: _authRefresh,
    redirect: (context, state) {
      final user = _safeCurrentUser();
      final location = state.uri.path;
      final isAuthRoute = location == '/login' || location == '/signup';
      final isRoot = location == '/';

      if (user == null && !isAuthRoute && !isRoot) {
        return '/login';
      }
      if (user != null && isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const SplashScreen()),
      GoRoute(
        path: '/login',
        pageBuilder: (_, _) => _fade(const LoginScreen()),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (_, _) => _fade(const SignUpScreen()),
      ),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/home', pageBuilder: (_, _) => _fade(const HomeScreen())),
      GoRoute(
        path: '/search',
        pageBuilder: (_, _) => _fade(const SearchScreen()),
      ),
      GoRoute(
        path: '/saved',
        pageBuilder: (_, _) => _fade(const SavedScreen()),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (_, _) => _fade(const ProfileScreen()),
      ),
      GoRoute(
        path: '/detail/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final recipe = state.extra is RecipeModel
              ? state.extra as RecipeModel
              : null;
          return _slide(RecipeDetailScreen(id: id, fallback: recipe));
        },
      ),
    ],
  );

  static CustomTransitionPage<void> _fade(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (_, animation, _, c) =>
          FadeTransition(opacity: animation, child: c),
    );
  }

  static CustomTransitionPage<void> _slide(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (_, animation, _, c) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(animation),
          child: c,
        );
      },
    );
  }

  static Stream<User?> _safeAuthStateChanges() {
    try {
      return FirebaseAuth.instance.authStateChanges();
    } catch (_) {
      return const Stream<User?>.empty();
    }
  }

  static User? _safeCurrentUser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (_) {
      return null;
    }
  }
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

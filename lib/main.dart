import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/recipe_repository.dart';
import 'data/services/auth_service.dart';
import 'data/services/recipe_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/recipe_provider.dart';
import 'presentation/providers/saved_provider.dart';
import 'presentation/providers/search_provider.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env').catchError((_) {});
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Allow non-Firebase local builds to start; auth will show a clear message.
  }
  await Hive.initFlutter();
  final savedBox = await Hive.openBox('saved_recipes');

  final authService = AuthService();
  final service = RecipeService();
  final repository = RecipeRepository(service);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<RecipeRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => AuthProvider(authService)),
        ChangeNotifierProvider(create: (_) => RecipeProvider(repository)),
        ChangeNotifierProvider(create: (_) => SearchProvider(repository)),
        ChangeNotifierProvider(create: (_) => SavedProvider(savedBox)),
      ],
      child: const WasftyApp(),
    ),
  );
}

class WasftyApp extends StatelessWidget {
  const WasftyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Wasfty',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}

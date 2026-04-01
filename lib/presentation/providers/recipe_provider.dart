import 'package:flutter/foundation.dart';

import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeProvider(this._repository);

  final RecipeRepository _repository;

  final List<String> categories = const [
    'All',
    'Main Course',
    'Breakfast',
    'Dessert',
    'Salad',
    'Soup',
  ];

  List<RecipeModel> popularRecipes = [];
  List<RecipeModel> recommendedRecipes = [];

  String selectedCategory = 'All';
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadHome() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      popularRecipes = await _repository.getPopularRecipes(type: selectedCategory);
      recommendedRecipes = await _repository.getRandomRecipes();
    } on AppException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(String value) async {
    selectedCategory = value;
    await loadHome();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}


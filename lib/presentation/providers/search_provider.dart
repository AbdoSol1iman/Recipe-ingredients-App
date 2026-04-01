import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../data/services/recipe_service.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._repository);

  final RecipeRepository _repository;
  Timer? _debounce;

  String query = '';
  bool isLoading = false;
  String? errorMessage;
  List<RecipeModel> results = [];
  List<String> suggestions = [];

  String cuisine = '';
  String diet = '';
  String maxReadyTime = '';

  Map<String, dynamic> get filters => {
    if (cuisine.isNotEmpty) 'cuisine': cuisine,
    if (diet.isNotEmpty) 'diet': diet,
    if (maxReadyTime.isNotEmpty) 'maxReadyTime': maxReadyTime,
  };

  Future<void> loadDefaultFilters() async {
    final prefs = await SharedPreferences.getInstance();
    diet = prefs.getString('default_diet') ?? '';
    notifyListeners();
  }

  void onQueryChanged(String value) {
    query = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await Future.wait([search(), loadSuggestions()]);
    });
    notifyListeners();
  }

  Future<void> loadSuggestions() async {
    try {
      suggestions = await _repository.autocomplete(query);
    } on AppException catch (e) {
      errorMessage = e.message;
      suggestions = [];
    } catch (_) {
      suggestions = [];
    }
    notifyListeners();
  }

  Future<void> search() async {
    if (query.trim().isEmpty) {
      results = [];
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      results = await _repository.searchRecipes(query, filters: filters);
    } on AppException catch (e) {
      errorMessage = e.message;
      results = [];
    } catch (_) {
      errorMessage = 'Could not search recipes. Try again.';
      results = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyFilters({
    required String cuisineValue,
    required String dietValue,
    required String maxReadyTimeValue,
  }) async {
    cuisine = cuisineValue;
    diet = dietValue;
    maxReadyTime = maxReadyTimeValue;
    await search();
  }

  void setDefaultDiet(String value) {
    diet = value;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

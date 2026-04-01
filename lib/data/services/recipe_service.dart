import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/recipe_detail_model.dart';
import '../models/recipe_model.dart';

class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RecipeService {
  final http.Client _client = http.Client();

  void _validateApiKey() {
    // TheMealDB requires no API key
  }

  Future<List<RecipeModel>> getPopularRecipes({String? type}) async {
    try {
      _validateApiKey();
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.randomPath}'),
        headers: ApiConstants.headers,
      );
      _throwIfError(response);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final meal = data['meals'] as List?;
      if (meal == null || meal.isEmpty) return [];
      return [RecipeModel.fromJson(meal[0] as Map<String, dynamic>)];
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to load popular recipes: $e');
    }
  }

  Future<List<RecipeModel>> getRandomRecipes() async {
    try {
      final List<RecipeModel> recipes = [];
      for (int i = 0; i < 5; i++) {
        final response = await _client.get(
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.randomPath}'),
          headers: ApiConstants.headers,
        );
        _throwIfError(response);
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final meals = data['meals'] as List?;
        if (meals != null && meals.isNotEmpty) {
          recipes.add(RecipeModel.fromJson(meals[0] as Map<String, dynamic>));
        }
      }
      return recipes;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to load recommended recipes: $e');
    }
  }

  Future<RecipeDetailModel> getRecipeDetail(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.lookupPath}').replace(
          queryParameters: {'i': id.toString()},
        ),
        headers: ApiConstants.headers,
      );
      _throwIfError(response);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) {
        throw const AppException('Recipe not found');
      }
      return RecipeDetailModel.fromJson(meals[0] as Map<String, dynamic>);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to load recipe details: $e');
    }
  }

  Future<List<RecipeModel>> searchRecipes(
    String query, {
    Map<String, dynamic> filters = const {},
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchPath}').replace(
          queryParameters: {'s': query},
        ),
        headers: ApiConstants.headers,
      );
      _throwIfError(response);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = data['meals'] as List? ?? const [];
      return meals
          .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to search recipes: $e');
    }
  }

  Future<List<String>> getAutocompleteSuggestions(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchPath}').replace(
          queryParameters: {'s': query},
        ),
        headers: ApiConstants.headers,
      );
      _throwIfError(response);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = data['meals'] as List? ?? const [];
      return meals
          .map((e) => (e['strMeal'] ?? '').toString())
          .where((e) => e.isNotEmpty)
          .toList();
    } catch (e) {
      if (e is AppException) rethrow;
      return [];
    }
  }

  Future<List<RecipeModel>> getSimilarRecipes(int id) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.randomPath}'),
        headers: ApiConstants.headers,
      );
      _throwIfError(response);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final meals = data['meals'] as List?;
      if (meals == null || meals.isEmpty) return [];
      return [RecipeModel.fromJson(meals[0] as Map<String, dynamic>)];
    } catch (e) {
      if (e is AppException) rethrow;
      return [];
    }
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw AppException('Request failed (${response.statusCode}): ${response.body}');
  }
}

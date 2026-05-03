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

  Future<List<RecipeModel>> getPopularRecipes({String? type}) async {
    try {
      if (type != null && type.isNotEmpty && type != 'All') {
        final category = _categoryToApi(type);
        final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterPath}')
            .replace(queryParameters: {'c': category});

        final response = await _client.get(uri, headers: ApiConstants.headers);
        _throwIfError(response);

        final meals = _extractMeals(response.body);
        return meals.take(10).map(RecipeModel.fromJson).toList();
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchPath}')
          .replace(queryParameters: {'s': ''});

      final response = await _client.get(uri, headers: ApiConstants.headers);
      _throwIfError(response);

      final meals = _extractMeals(response.body);
      return meals.take(10).map(RecipeModel.fromJson).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to load popular recipes: $e');
    }
  }

  Future<List<RecipeModel>> getRandomRecipes() async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.randomPath}');
      final results = <RecipeModel>[];
      final seen = <int>{};

      while (results.length < 5) {
        final response = await _client.get(uri, headers: ApiConstants.headers);
        _throwIfError(response);

        final meals = _extractMeals(response.body);
        if (meals.isEmpty) {
          break;
        }

        final recipe = RecipeModel.fromJson(meals.first);
        if (seen.add(recipe.id)) {
          results.add(recipe);
        }
      }

      return results;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to load recommended recipes: $e');
    }
  }

  Future<RecipeDetailModel> getRecipeDetail(int id) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.lookupPath}')
          .replace(queryParameters: {'i': '$id'});

      final response = await _client.get(uri, headers: ApiConstants.headers);
      _throwIfError(response);

      final meals = _extractMeals(response.body);
      if (meals.isEmpty) {
        throw const AppException('Recipe not found.');
      }

      return RecipeDetailModel.fromJson(meals.first);
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
      Uri uri;
      final cuisine = (filters['cuisine'] ?? '').toString().trim();
      if (query.trim().isEmpty && cuisine.isNotEmpty) {
        uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterPath}')
            .replace(queryParameters: {'a': cuisine});
      } else {
        uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchPath}')
            .replace(queryParameters: {'s': query.trim()});
      }

      final response = await _client.get(uri, headers: ApiConstants.headers);
      _throwIfError(response);

      final meals = _extractMeals(response.body);
      final mapped = meals.map(RecipeModel.fromJson).toList();
      return mapped.take(20).toList();
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException('Failed to search recipes: $e');
    }
  }

  Future<List<String>> getAutocompleteSuggestions(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchPath}')
          .replace(queryParameters: {'s': query});

      final response = await _client.get(uri, headers: ApiConstants.headers);
      _throwIfError(response);

      final meals = _extractMeals(response.body);
      final lower = query.toLowerCase();
      return meals
          .map((e) => (e['strMeal'] ?? '').toString())
          .where((e) => e.isNotEmpty && e.toLowerCase().contains(lower))
          .take(5)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<RecipeModel>> getSimilarRecipes(int id) async {
    try {
      final detail = await getRecipeDetail(id);
      final category = detail.diets.isNotEmpty ? detail.diets.first : '';
      if (category.isEmpty) {
        return [];
      }

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.filterPath}')
          .replace(queryParameters: {'c': category});

      final response = await _client.get(uri, headers: ApiConstants.headers);
      _throwIfError(response);

      final meals = _extractMeals(response.body)
          .map(RecipeModel.fromJson)
          .where((recipe) => recipe.id != id)
          .take(4)
          .toList();
      return meals;
    } catch (e) {
      if (e is AppException) rethrow;
      return [];
    }
  }

  String _categoryToApi(String category) {
    switch (category.toLowerCase()) {
      case 'main course':
        return 'Beef';
      case 'breakfast':
        return 'Breakfast';
      case 'dessert':
        return 'Dessert';
      case 'salad':
        return 'Vegetarian';
      case 'soup':
        return 'Starter';
      default:
        return category;
    }
  }

  List<Map<String, dynamic>> _extractMeals(String body) {
    final data = jsonDecode(body) as Map<String, dynamic>;
    final meals = data['meals'];
    if (meals is! List) {
      return const [];
    }

    return meals
        .whereType<Map>()
        .map((item) => item.map(
              (key, value) => MapEntry(key.toString(), value),
            ))
        .toList();
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw AppException(
        'Request failed (${response.statusCode}): ${response.body}');
  }
}
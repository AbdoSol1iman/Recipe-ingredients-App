import '../models/recipe_detail_model.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeRepository {
  const RecipeRepository(this._service);

  final RecipeService _service;

  Future<List<RecipeModel>> getPopularRecipes({String? type}) {
    return _service.getPopularRecipes(type: type);
  }

  Future<List<RecipeModel>> getRandomRecipes() {
    return _service.getRandomRecipes();
  }

  Future<RecipeDetailModel> getRecipeDetail(int id) {
    return _service.getRecipeDetail(id);
  }

  Future<List<RecipeModel>> searchRecipes(
    String query, {
    Map<String, dynamic> filters = const {},
  }) {
    return _service.searchRecipes(query, filters: filters);
  }

  Future<List<String>> autocomplete(String query) {
    return _service.getAutocompleteSuggestions(query);
  }

  Future<List<RecipeModel>> getSimilarRecipes(int id) {
    return _service.getSimilarRecipes(id);
  }
}


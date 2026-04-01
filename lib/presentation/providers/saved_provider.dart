import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../data/models/recipe_model.dart';

class SavedProvider extends ChangeNotifier {
  SavedProvider(this._box) {
    _loadSaved();
  }

  final Box _box;
  final List<RecipeModel> _savedRecipes = [];

  List<RecipeModel> get savedRecipes => List.unmodifiable(_savedRecipes);

  void _loadSaved() {
    _savedRecipes
      ..clear()
      ..addAll(
        _box.values
            .map((e) => RecipeModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
    notifyListeners();
  }

  bool isSaved(int recipeId) {
    return _box.containsKey(recipeId.toString());
  }

  Future<void> toggleSaved(RecipeModel recipe) async {
    final key = recipe.id.toString();
    if (_box.containsKey(key)) {
      await _box.delete(key);
    } else {
      await _box.put(key, recipe.toJson());
    }
    _loadSaved();
  }

  Future<void> removeSaved(int recipeId) async {
    await _box.delete(recipeId.toString());
    _loadSaved();
  }
}


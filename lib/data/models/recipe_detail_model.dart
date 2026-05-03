import 'ingredient_model.dart';

class RecipeDetailModel {
  const RecipeDetailModel({
    required this.id,
    required this.title,
    required this.image,
    required this.servings,
    required this.readyInMinutes,
    required this.diets,
    required this.ingredients,
    required this.instructions,
    required this.nutrients,
  });

  final int id;
  final String title;
  final String image;
  final int servings;
  final int readyInMinutes;
  final List<String> diets;
  final List<IngredientModel> ingredients;
  final List<String> instructions;
  final Map<String, String> nutrients;

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <IngredientModel>[];
    
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] ?? '';
      final measure = json['strMeasure$i'] ?? '';
      
      if (ingredient.toString().isNotEmpty) {
        ingredients.add(IngredientModel(
          name: ingredient.toString(),
          amount: 1,
          unit: measure.toString(),
          image: 'https://www.themealdb.com/images/ingredients/$ingredient-Small.png',
        ));
      }
    }

    return RecipeDetailModel(
      id: int.tryParse((json['idMeal'] ?? '0').toString()) ?? 0,
      title: (json['strMeal'] ?? '').toString(),
      image: (json['strMealThumb'] ?? '').toString(),
      servings: 1,
      readyInMinutes: 30,
      diets: [(json['strCategory'] ?? '').toString()].where((e) => e.isNotEmpty).toList(),
      ingredients: ingredients,
      instructions: _parseInstructions(json['strInstructions'] ?? ''),
      nutrients: {},
    );
  }

  static List<String> _parseInstructions(String instructions) {
    if (instructions.isEmpty) return [];
    return instructions
        .split('. ')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
}

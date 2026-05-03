class RecipeModel {
  const RecipeModel({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.diets,
    required this.dishTypes,
  });

  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final List<String> diets;
  final List<String> dishTypes;

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final idStr = (json['idMeal'] ?? json['id'] ?? '0').toString();
    return RecipeModel(
      id: int.tryParse(idStr) ?? 0,
      title: (json['strMeal'] ?? json['title'] ?? '').toString(),
      image: (json['strMealThumb'] ?? json['image'] ?? '').toString(),
      readyInMinutes: json['readyInMinutes'] ?? 30,
      servings: json['servings'] ?? 1,
      diets: List<String>.from(json['diets'] ?? []),
      dishTypes: List<String>.from(json['dishTypes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMeal': id,
      'title': title,
      'strMeal': title,
      'image': image,
      'strMealThumb': image,
      'readyInMinutes': readyInMinutes,
      'servings': servings,
      'diets': diets,
      'dishTypes': dishTypes,
    };
  }
}

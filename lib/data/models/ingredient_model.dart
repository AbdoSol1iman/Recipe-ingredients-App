class IngredientModel {
  const IngredientModel({
    required this.name,
    required this.amount,
    required this.unit,
    required this.image,
  });

  final String name;
  final double amount;
  final String unit;
  final String image;

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      name: (json['name'] ?? '').toString(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      unit: (json['unit'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'amount': amount, 'unit': unit, 'image': image};
  }
}


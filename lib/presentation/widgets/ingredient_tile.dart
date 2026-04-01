import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/ingredient_model.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({super.key, required this.ingredient});

  final IngredientModel ingredient;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_dining_outlined, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(ingredient.name, style: AppTextStyles.bodyStrong),
          ),
          Text(
            '${ingredient.amount.toStringAsFixed(ingredient.amount.truncateToDouble() == ingredient.amount ? 0 : 1)} ${ingredient.unit}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}


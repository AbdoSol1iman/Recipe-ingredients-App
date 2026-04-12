import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../providers/saved_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/recipe_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SavedProvider>();
    final recipes = provider.savedRecipes;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      appBar: AppBar(title: const Text('Saved Recipes')),
      body: recipes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bookmark_border, size: 54),
                  const SizedBox(height: 8),
                  Text('No saved recipes yet', style: AppTextStyles.body),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Dismissible(
                  key: ValueKey(recipe.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => provider.removeSaved(recipe.id),
                  child: RecipeCard(
                    recipe: recipe,
                    heroTag: 'recipe_${recipe.id}',
                    isSaved: true,
                    onSaveTap: () => provider.removeSaved(recipe.id),
                    onTap: () => context.push('/detail/${recipe.id}', extra: recipe),
                  ),
                );
              },
            ),
    );
  }
}


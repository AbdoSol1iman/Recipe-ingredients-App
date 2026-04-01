import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/saved_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().loadHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
        provider.clearError();
      });
    }

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.loadHome,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Hello, Foodie', style: AppTextStyles.heading2),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => context.go('/search'),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search recipes',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.tune),
                      hintStyle: AppTextStyles.body,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: provider.categories
                      .map(
                        (category) => CategoryChip(
                          label: category,
                          selected: category == provider.selectedCategory,
                          onTap: () => provider.updateCategory(category),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 18),
              Text('Popular Recipes', style: AppTextStyles.title),
              const SizedBox(height: 10),
              if (provider.isLoading)
                _buildLoadingRow()
              else
                SizedBox(
                  height: 245,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.popularRecipes.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final recipe = provider.popularRecipes[index];
                      final isSaved = context.watch<SavedProvider>().isSaved(recipe.id);
                      return SizedBox(
                        width: 190,
                        child: RecipeCard(
                          recipe: recipe,
                          heroTag: 'recipe_${recipe.id}',
                          isSaved: isSaved,
                          onSaveTap: () => context.read<SavedProvider>().toggleSaved(recipe),
                          onTap: () => context.go('/detail/${recipe.id}', extra: recipe),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Text('Recommended', style: AppTextStyles.title),
              const SizedBox(height: 10),
              if (provider.isLoading)
                _buildLoadingColumn()
              else
                ...provider.recommendedRecipes.map(
                  (recipe) {
                    final isSaved = context.watch<SavedProvider>().isSaved(recipe.id);
                    return SizedBox(
                      height: 230,
                      child: RecipeCard(
                        recipe: recipe,
                        heroTag: 'recipe_${recipe.id}',
                        isSaved: isSaved,
                        onSaveTap: () => context.read<SavedProvider>().toggleSaved(recipe),
                        onTap: () => context.go('/detail/${recipe.id}', extra: recipe),
                      ),
                    );
                  },
                ),
              if (!provider.isLoading &&
                  provider.popularRecipes.isEmpty &&
                  provider.recommendedRecipes.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text('No recipes available.', style: AppTextStyles.body),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingRow() {
    return SizedBox(
      height: 225,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.border,
          highlightColor: Colors.white,
          child: Container(
            width: 190,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingColumn() {
    return Column(
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: AppColors.border,
            highlightColor: Colors.white,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


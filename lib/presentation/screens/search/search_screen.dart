import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/saved_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchProvider>().loadDefaultFilters();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    if (provider.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
        provider.clearError();
      });
    }

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: provider.onQueryChanged,
                      decoration: InputDecoration(
                        hintText: 'Search for recipes',
                        prefixIcon: const Icon(Icons.search),
                        hintStyle: AppTextStyles.body,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () => _showFilters(context, provider),
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (provider.suggestions.isNotEmpty)
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final suggestion = provider.suggestions[index];
                      return ActionChip(
                        label: Text(suggestion),
                        onPressed: () {
                          _controller.text = suggestion;
                          provider.onQueryChanged(suggestion);
                        },
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: provider.isLoading
                    ? _loadingGrid()
                    : provider.results.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.no_food_outlined,
                                    size: 56, color: AppColors.textSecondary),
                                const SizedBox(height: 10),
                                Text('No recipes found', style: AppTextStyles.body),
                              ],
                            ),
                          )
                        : GridView.builder(
                            itemCount: provider.results.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final recipe = provider.results[index];
                              final isSaved = context.watch<SavedProvider>().isSaved(recipe.id);
                              return RecipeCard(
                                recipe: recipe,
                                heroTag: 'recipe_${recipe.id}',
                                isSaved: isSaved,
                                onSaveTap: () =>
                                    context.read<SavedProvider>().toggleSaved(recipe),
                                onTap: () => context.go('/detail/${recipe.id}', extra: recipe),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadingGrid() {
    return GridView.builder(
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.border,
        highlightColor: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Future<void> _showFilters(BuildContext context, SearchProvider provider) async {
    final cuisineController = TextEditingController(text: provider.cuisine);
    final maxReadyController = TextEditingController(text: provider.maxReadyTime);
    String selectedDiet = provider.diet;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filters', style: AppTextStyles.title),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cuisineController,
                    decoration: const InputDecoration(labelText: 'Cuisine'),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDiet.isEmpty ? null : selectedDiet,
                    decoration: const InputDecoration(labelText: 'Diet'),
                    items: const [
                      DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
                      DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                      DropdownMenuItem(value: 'ketogenic', child: Text('Ketogenic')),
                      DropdownMenuItem(value: 'gluten free', child: Text('Gluten Free')),
                    ],
                    onChanged: (value) => setSheetState(() => selectedDiet = value ?? ''),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: maxReadyController,
                    decoration: const InputDecoration(labelText: 'Max Ready Time (min)'),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      onPressed: () async {
                        await provider.applyFilters(
                          cuisineValue: cuisineController.text.trim(),
                          dietValue: selectedDiet.trim(),
                          maxReadyTimeValue: maxReadyController.text.trim(),
                        );
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}


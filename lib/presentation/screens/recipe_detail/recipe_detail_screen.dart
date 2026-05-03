import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/recipe_detail_model.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../providers/saved_provider.dart';
import '../../widgets/ingredient_tile.dart';
import '../../widgets/nutrition_badge.dart';
import '../../widgets/recipe_card.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.id, required this.fallback});

  final int id;
  final RecipeModel? fallback;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  RecipeDetailModel? detail;
  List<RecipeModel> similar = [];
  bool isLoading = true;
  String? error;

  late final TabController _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final repository = context.read<RecipeRepository>();
      final loadedDetail = await repository.getRecipeDetail(widget.id);
      final loadedSimilar = await repository.getSimilarRecipes(widget.id);
      if (!mounted) return;
      setState(() {
        detail = loadedDetail;
        similar = loadedSimilar;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => error = 'Could not load recipe details.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not load recipe details.')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fallback = widget.fallback;
    final data = detail;
    final imageUrl = data?.image ?? fallback?.image ?? '';
    final title = data?.title ?? fallback?.title ?? 'Recipe';
    final ready = data?.readyInMinutes ?? fallback?.readyInMinutes ?? 0;
    final servings = data?.servings ?? fallback?.servings ?? 0;
    final isSaved = fallback != null && context.watch<SavedProvider>().isSaved(fallback.id);

    return Scaffold(
      body: isLoading
          ? _loadingView()
          : error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(error!, style: AppTextStyles.body),
                      const SizedBox(height: 8),
                      FilledButton(onPressed: _load, child: const Text('Retry')),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 260,
                      pinned: true,
                      leading: IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      actions: [
                        if (fallback != null)
                          IconButton(
                            onPressed: () =>
                                context.read<SavedProvider>().toggleSaved(fallback),
                            icon: Icon(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                            ),
                          ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: 'recipe_${widget.id}',
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              color: AppColors.border,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: AppTextStyles.heading2),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.schedule, size: 16),
                                const SizedBox(width: 4),
                                Text('$ready min', style: AppTextStyles.caption),
                                const SizedBox(width: 16),
                                const Icon(Icons.people_alt_outlined, size: 16),
                                const SizedBox(width: 4),
                                Text('$servings servings', style: AppTextStyles.caption),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (data?.diets ?? const <String>[])
                                  .map(
                                    (diet) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(diet, style: AppTextStyles.caption),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            TabBar(
                              controller: _tabController,
                              labelColor: AppColors.primary,
                              unselectedLabelColor: AppColors.textSecondary,
                              tabs: const [
                                Tab(text: 'Ingredients'),
                                Tab(text: 'Instructions'),
                                Tab(text: 'Nutrition'),
                              ],
                            ),
                            SizedBox(
                              height: 340,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ListView(
                                    children: (data?.ingredients ?? const [])
                                        .map((ingredient) => IngredientTile(ingredient: ingredient))
                                        .toList(),
                                  ),
                                  ListView(
                                    children: (data?.instructions ?? const [])
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => ListTile(
                                            leading: CircleAvatar(
                                              radius: 12,
                                              child: Text('${entry.key + 1}'),
                                            ),
                                            title: Text(entry.value, style: AppTextStyles.body),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                  GridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    children: [
                                      NutritionBadge(
                                        label: 'Calories',
                                        value: data?.nutrients['calories'] ?? 'N/A',
                                      ),
                                      NutritionBadge(
                                        label: 'Protein',
                                        value: data?.nutrients['protein'] ?? 'N/A',
                                      ),
                                      NutritionBadge(
                                        label: 'Carbs',
                                        value: data?.nutrients['carbohydrates'] ?? 'N/A',
                                      ),
                                      NutritionBadge(
                                        label: 'Fat',
                                        value: data?.nutrients['fat'] ?? 'N/A',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text('Similar recipes', style: AppTextStyles.title),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 220,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: similar.length,
                                separatorBuilder: (_, _) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final item = similar[index];
                                  return SizedBox(
                                    width: 180,
                                    child: RecipeCard(
                                      recipe: item,
                                      heroTag: 'recipe_${item.id}',
                                      isSaved: context.watch<SavedProvider>().isSaved(item.id),
                                      onSaveTap: () =>
                                          context.read<SavedProvider>().toggleSaved(item),
                                      onTap: () => context.push(
                                        '/detail/${item.id}',
                                        extra: item,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: Colors.white,
      child: ListView(
        children: [
          Container(height: 260, color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(
                6,
                (_) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/saved_provider.dart';
import '../../widgets/bottom_nav_bar.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _ingredientController = TextEditingController();
  final _stepController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _steps = [];
  static const List<String> _categories = [
    'Main Course',
    'Breakfast',
    'Dessert',
    'Salad',
    'Soup',
  ];
  String? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _cookTimeController.dispose();
    _ingredientController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      appBar: AppBar(title: const Text('Add your recipe')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _HeaderCard(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Recipe title',
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) => _required(value, 'Add a title'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                minLines: 3,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Short description',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.notes_outlined),
                ),
                validator: (value) => _required(value, 'Add some details'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Image URL (optional)',
                  prefixIcon: Icon(Icons.image_outlined),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _categories
                          .map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedCategory = value);
                      },
                      validator: (value) =>
                          value == null ? 'Add a category' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _cookTimeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Cook time',
                        suffixText: 'min',
                      ),
                      validator: _validateCookTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _EditableListSection(
                title: 'Ingredients',
                hintText: 'Add ingredient',
                icon: Icons.add_circle_outline,
                controller: _ingredientController,
                values: _ingredients,
                onAdd: () => _addListItem(_ingredientController, _ingredients),
                onRemove: (index) =>
                    setState(() => _ingredients.removeAt(index)),
              ),
              const SizedBox(height: 18),
              _EditableListSection(
                title: 'Steps',
                hintText: 'Add cooking step',
                icon: Icons.playlist_add,
                controller: _stepController,
                values: _steps,
                numbered: true,
                onAdd: () => _addListItem(_stepController, _steps),
                onRemove: (index) => setState(() => _steps.removeAt(index)),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _submit,
                icon: const Icon(Icons.send_outlined),
                label: const Text('Submit recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addListItem(TextEditingController controller, List<String> values) {
    final value = controller.text.trim();
    if (value.isEmpty) return;
    setState(() {
      values.add(value);
      controller.clear();
    });
  }

  Future<void> _submit() async {
    final validForm = _formKey.currentState?.validate() ?? false;

    if (_ingredients.isEmpty) {
      _showMessage('Add at least one ingredient.');
      return;
    }
    if (_steps.isEmpty) {
      _showMessage('Add at least one cooking step.');
      return;
    }
    if (!validForm) return;

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final recipeModel = <String, dynamic>{
      'id': timestamp,
      'idMeal': timestamp,
      'title': _titleController.text.trim(),
      'strMeal': _titleController.text.trim(),
      'image': _imageUrlController.text.trim(),
      'strMealThumb': _imageUrlController.text.trim(),
      'readyInMinutes': int.parse(_cookTimeController.text.trim()),
      'servings': 1,
      'diets': [_selectedCategory],
      'dishTypes': _steps,
      'ingredients': _ingredients,
    };

    try {
      final savedBox = await Hive.openBox('saved_recipes');
      await savedBox.put(timestamp.toString(), recipeModel);
      if (mounted) {
        context.read<SavedProvider>().reloadSaved();
      }
    } on HiveError catch (error) {
      _showMessage('Could not save recipe: $error');
      return;
    }

    _showMessage('Recipe saved to Favourite! Check the Saved Recipes page.');
    _clearForm();
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _imageUrlController.clear();
    _cookTimeController.clear();
    _ingredientController.clear();
    _stepController.clear();
    setState(() {
      _selectedCategory = null;
      _ingredients.clear();
      _steps.clear();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _required(String? value, String message) {
    return value == null || value.trim().isEmpty ? message : null;
  }

  String? _validateCookTime(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Add cook time';
    final minutes = int.tryParse(text);
    if (minutes == null || minutes <= 0) return 'Use minutes';
    return null;
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.restaurant_menu, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Share with Wasfty', style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(
                  'Share with Wasfty will be a feature soon.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableListSection extends StatelessWidget {
  const _EditableListSection({
    required this.title,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.values,
    required this.onAdd,
    required this.onRemove,
    this.numbered = false,
  });

  final String title;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final List<String> values;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: Icon(icon),
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (values.isEmpty)
          Text('No $title added yet.', style: AppTextStyles.caption)
        else
          ...values.indexed.map((entry) {
            final index = entry.$1;
            final value = entry.$2;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 14,
                  child: Text(numbered ? '${index + 1}' : '•'),
                ),
                title: Text(value),
                trailing: IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.close),
                  onPressed: () => onRemove(index),
                ),
              ),
            );
          }),
      ],
    );
  }
}

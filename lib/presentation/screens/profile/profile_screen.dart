import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/saved_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedCount = context.watch<SavedProvider>().savedRecipes.length;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(radius: 38, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 12),
          Center(child: Text('Guest Chef', style: AppTextStyles.heading2)),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Saved recipes: $savedCount',
              style: AppTextStyles.body,
            ),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.restaurant_menu_outlined),
            title: const Text('Dietary preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openDietDialog(context),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notifications'),
            trailing: Icon(Icons.chevron_right),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('Wasfty v1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              await context.read<AuthProvider>().signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openDietDialog(BuildContext context) async {
    String selected = context.read<SearchProvider>().diet;
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Default Diet Preference'),
        content: DropdownButtonFormField<String>(
          initialValue: selected.isEmpty ? null : selected,
          items: const [
            DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
            DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
            DropdownMenuItem(value: 'ketogenic', child: Text('Ketogenic')),
            DropdownMenuItem(value: 'gluten free', child: Text('Gluten Free')),
          ],
          onChanged: (value) => selected = value ?? '',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('default_diet', selected);
              if (context.mounted) {
                context.read<SearchProvider>().setDefaultDiet(selected);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

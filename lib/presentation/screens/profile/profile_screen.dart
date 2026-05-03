import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasftk/presentation/screens/auth/login_screen.dart';
import 'package:wasftk/presentation/screens/bmi/bmi_Screen.dart';
import 'package:wasftk/presentation/screens/calorie_tracker/calorie_tracker_screen.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/saved_provider.dart';
import '../../providers/search_provider.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedCount = context.watch<SavedProvider>().savedRecipes.length;

    return Scaffold(
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 4),
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
          ListTile(
            leading: Icon(Icons.monitor_weight_outlined),
            title: Text('BMI Calculator'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BmiAppScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.local_fire_department_outlined),
            title: Text('Calorie Tracker'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CalorieTrackerScreen()),
              );
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('Wasfty v1.0.0'),
          ),
          const Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.logout, color: Colors.red),
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
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

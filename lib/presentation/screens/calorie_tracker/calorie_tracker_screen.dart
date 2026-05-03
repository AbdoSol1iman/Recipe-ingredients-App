import 'package:flutter/material.dart';

class Food {
  final String name;
  final double caloriesPer100g;
  final IconData icon;
  final String category;

  Food(this.name, this.caloriesPer100g, this.icon, this.category);
}

class CalorieTrackerScreen extends StatefulWidget {
  @override
  _CalorieTrackerScreenState createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final Color primaryColor = Color(0xFF6FB7B3);

  List<String> categories = [
    "All",
    "Protein",
    "Carbs",
    "Dairy",
    "Fruits",
    "Vegetables",
    "Fast Food",
    "Snacks",
  ];

  String selectedCategory = "All";

  List<Food> foods = [
    // Protein
    Food("Chicken Breast", 165, Icons.set_meal, "Protein"),
    Food("Beef", 250, Icons.lunch_dining, "Protein"),
    Food("Egg", 155, Icons.egg, "Protein"),
    Food("Tuna", 132, Icons.set_meal, "Protein"),
    Food("Salmon", 208, Icons.set_meal, "Protein"),

    // Carbs
    Food("Rice", 130, Icons.rice_bowl, "Carbs"),
    Food("Pasta", 131, Icons.ramen_dining, "Carbs"),
    Food("Bread", 265, Icons.bakery_dining, "Carbs"),
    Food("Oats", 389, Icons.breakfast_dining, "Carbs"),
    Food("Potato", 77, Icons.fastfood, "Carbs"),

    // Dairy
    Food("Milk", 42, Icons.local_drink, "Dairy"),
    Food("Cheese", 402, Icons.icecream, "Dairy"),
    Food("Yogurt", 59, Icons.icecream, "Dairy"),

    // Fruits
    Food("Apple", 52, Icons.apple, "Fruits"),
    Food("Banana", 89, Icons.food_bank, "Fruits"),
    Food("Orange", 47, Icons.circle, "Fruits"),
    Food("Strawberry", 33, Icons.circle, "Fruits"),
    Food("Mango", 60, Icons.circle, "Fruits"),

    // Vegetables
    Food("Broccoli", 34, Icons.eco, "Vegetables"),
    Food("Carrot", 41, Icons.eco, "Vegetables"),
    Food("Tomato", 18, Icons.eco, "Vegetables"),
    Food("Cucumber", 16, Icons.eco, "Vegetables"),

    // Fast Food
    Food("Burger", 295, Icons.fastfood, "Fast Food"),
    Food("Pizza", 266, Icons.local_pizza, "Fast Food"),
    Food("Fries", 312, Icons.fastfood, "Fast Food"),

    // Snacks
    Food("Chocolate", 546, Icons.cookie, "Snacks"),
    Food("Biscuits", 502, Icons.cookie, "Snacks"),
    Food("Ice Cream", 207, Icons.icecream, "Snacks"),
  ];

  Food? selectedFood;
  TextEditingController gramsController = TextEditingController();

  double result = 0;

  List<Food> get filteredFoods {
    if (selectedCategory == "All") return foods;
    return foods.where((f) => f.category == selectedCategory).toList();
  }

  void calculate() {
    double grams = double.tryParse(gramsController.text) ?? 0;

    if (selectedFood != null) {
      setState(() {
        result = (grams / 100) * selectedFood!.caloriesPer100g;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7F7),
      appBar: AppBar(
        title: Text("Calorie Tracker"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔥 Responsive Categories Scroll
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: primaryColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onSelected: (val) {
                        setState(() {
                          selectedCategory = cat;
                          selectedFood = null;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 15),

            // 🔽 Food Selector
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<Food>(
                hint: Text("Select Food"),
                value: selectedFood,
                isExpanded: true,
                underline: SizedBox(),
                items: filteredFoods.map((food) {
                  return DropdownMenuItem(
                    value: food,
                    child: Row(
                      children: [
                        Icon(food.icon, color: primaryColor),
                        SizedBox(width: 10),
                        Text(food.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFood = value;
                  });
                },
              ),
            ),

            SizedBox(height: 20),

            // 🔽 Input grams
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              padding: EdgeInsets.all(12),
              child: TextField(
                controller: gramsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter grams",
                  prefixIcon: Icon(Icons.scale, color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // 🔘 Calculate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: calculate,
                child: Text(
                  "Calculate Calories",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            // 🔥 Result Card
            Card(
              color: Color(0xFFE8F4F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 40,
                      color: primaryColor,
                    ),
                    SizedBox(height: 10),
                    Text("Calories"),
                    SizedBox(height: 10),
                    Text(
                      "${result.toStringAsFixed(1)} kcal",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

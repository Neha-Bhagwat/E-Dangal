import 'package:flutter/material.dart';
import '../home/home_screen.dart';


class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<Map<String, String>> categories = [
    {"name": "Electronics", "icon": "💻"},
    {"name": "Fashion", "icon": "👗"},
    {"name": "Food & Drinks", "icon": "🍔"},
    {"name": "Books", "icon": "📚"},
    {"name": "Fitness", "icon": "🏋️"},
    {"name": "Beauty", "icon": "💄"},
    {"name": "Home Decor", "icon": "🛋️"},
    {"name": "Automobiles", "icon": "🚗"},
    {"name": "Travel", "icon": "✈️"},
  ];

  final Set<String> selectedCategories = {};
  String searchQuery = "";

  void toggleSelection(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        if (selectedCategories.length < 6) {
          selectedCategories.add(category);
        }
      }
    });
  }

  List<Map<String, String>> get filteredCategories {
    return categories
        .where((cat) => cat['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Interests"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose up to 6 categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search categories...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: filteredCategories.map((category) {
                    final name = category['name']!;
                    final icon = category['icon']!;
                    final isSelected = selectedCategories.contains(name);

                    return GestureDetector(
                      onTap: () => toggleSelection(name),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3 - 24,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blueAccent : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(icon, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 5),
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${selectedCategories.length} of 6 selected"),
                ElevatedButton(
                  onPressed: selectedCategories.length >= 6
                      ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text("Continue"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

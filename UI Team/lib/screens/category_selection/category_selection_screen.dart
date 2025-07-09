import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  _CategorySelectionScreenState createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<Map<String, String>> categories = [
    {"name": "Electronics", "image": "assets/images/electronics.jpg"},
    {"name": "Fashion", "image": "assets/images/fashion.jpg"},
    {"name": "Drinks", "image": "assets/images/drinks.jpg"},
    {"name": "Education", "image": "assets/images/education.png"},
    {"name": "FMCG", "image": "assets/images/fmcg.jpg"},
    {"name": "Beauty", "image": "assets/images/Beauty.jpg"},
    {"name": "Healthcare", "image": "assets/images/healthcare.jpg"},
    {"name": "Automobiles", "image": "assets/images/automobiles.jpg"},
    {"name": "Hygiene", "image": "assets/images/hygiene.png"},
    {"name": "Sports", "image": "assets/images/sports.png"},
  ];

  final List<Map<String, String>> selectedCategories = [];
  String searchQuery = "";

  void toggleSelection(Map<String, String> category) {
    setState(() {
      final exists = selectedCategories.any((c) => c['name'] == category['name']);
      if (exists) {
        selectedCategories.removeWhere((c) => c['name'] == category['name']);
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: SafeArea(
        child: Padding(
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
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                  children: filteredCategories.map((category) {
                    final name = category['name']!;
                    final imagePath = category['image']!;
                    final isSelected = selectedCategories.any((c) => c['name'] == name);

                    return GestureDetector(
                      onTap: () => toggleSelection(category),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF7643) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF7643), width: isSelected ? 2 : 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${selectedCategories.length} of 6 selected"),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: selectedCategories.length >= 6
                          ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              selectedCategories: selectedCategories,
                            ),
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7643),
                      ),
                      child: const Text("Continue"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

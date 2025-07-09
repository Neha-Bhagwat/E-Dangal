import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../category_selection/category_selection_screen.dart';

class Categories extends StatelessWidget {
  final List<Map<String, dynamic>> selectedCategories;
  const Categories({super.key, required this.selectedCategories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.start,
            children: selectedCategories.map((category) {
              return CategoryCard(
                icon: category["image"],
                text: category["name"],
                press: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Clicked on ${category["name"]}")),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategorySelectionScreen(),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF7643),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add New Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon.endsWith(".svg")
                ? SvgPicture.asset(icon)
                : Image.asset(icon, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 90,
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}

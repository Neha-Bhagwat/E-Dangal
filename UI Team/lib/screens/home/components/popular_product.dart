import 'package:flutter/material.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  final List<String> insights = const [
    "📍 In Mumbai, most people prefer Dove over Lux",
    "⭐ Colgate is the #1 choice this week",
    "🥤 Pepsi beats Coke in Delhi this month",
    "👟 Nike is trending among youth in Pune",
    "🍫 Dairy Milk outshines 5 Star in Chennai",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Brands Insights",
            press: () {},
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal Scrollable Insight Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Row(
            children: insights.asMap().entries.map((entry) {
              final index = entry.key;
              final insight = entry.value;

              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(milliseconds: 500 + index * 200),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A3298),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    insight,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}

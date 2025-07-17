import 'package:flutter/material.dart';

import 'components/categories.dart';
import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  final List<Map<String, dynamic>> selectedCategories;
  final String userName;
  final int questionsAnswered;

  const HomeScreen({
    super.key,
    required this.selectedCategories,
    required this.userName,
    this.questionsAnswered = 3, // You can update this dynamically later
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(
                userName: userName,

                questionsAnswered: questionsAnswered,
              ),
              DiscountBanner(questionsAnswered: questionsAnswered),
              Categories(selectedCategories: selectedCategories),
              SpecialOffers(questionsAnswered: 12), // You can make this dynamic too
              const SizedBox(height: 20),
              const PopularProducts(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

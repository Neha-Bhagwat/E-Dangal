import 'package:flutter/material.dart';

class DiscountBanner extends StatelessWidget {
  final int questionsAnswered;
  final int totalQuestions;

  const DiscountBanner({
    Key? key,
    required this.questionsAnswered,
    this.totalQuestions = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int remaining = totalQuestions - questionsAnswered;
    double progress = questionsAnswered / totalQuestions;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Goal Text
          Text(
            "🎯 Answer $remaining more questions to unlock a ₹50 Amazon coupon!",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            ),
          ),
          const SizedBox(height: 10),

          // Progress Count
          Text(
            "$questionsAnswered / $totalQuestions completed",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 15),

          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // This assumes you have registered this route in your main.dart
                Navigator.pushNamed(context, "/questionScreen");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Continue Questions →",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

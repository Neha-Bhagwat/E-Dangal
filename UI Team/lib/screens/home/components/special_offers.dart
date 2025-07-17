import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class SpecialOffers extends StatefulWidget {
  final int questionsAnswered;

  const SpecialOffers({
    Key? key,
    required this.questionsAnswered,
  }) : super(key: key);

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  late ConfettiController _confettiController;

  final List<Map<String, dynamic>> earnedRewards = [
    {"title": "Flipkart ₹100 Coupon", "threshold": 10},
    {"title": "Amazon ₹50 Coupon", "threshold": 15},
  ];

  final List<Map<String, dynamic>> upcomingRewards = [
    {"title": "Myntra ₹100 Coupon", "threshold": 20},
    {"title": "Zomato ₹75 Coupon", "threshold": 25},
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void triggerConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "🎁 Your Rewards",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3298),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  // Earned Rewards
                  ...earnedRewards.map((reward) {
                    double progress = 1.0; // Fully completed
                    return GestureDetector(
                      onTap: triggerConfetti,
                      child: rewardCard(
                        title: reward["title"],
                        subtitle: "Claimed ✅",
                        icon: Icons.emoji_events,
                        iconColor: Colors.greenAccent,
                        progress: progress,
                        progressColor: Colors.greenAccent,
                      ),
                    );
                  }),

                  // Upcoming Rewards
                  ...upcomingRewards.map((reward) {
                    int threshold = reward["threshold"];
                    int answered = widget.questionsAnswered;
                    int remaining = threshold - answered;
                    double progress = (answered / threshold).clamp(0.0, 1.0);

                    return rewardCard(
                      title: reward["title"],
                      subtitle: "Answer $remaining more",
                      icon: Icons.lock_outline,
                      iconColor: Colors.orangeAccent,
                      progress: progress,
                      progressColor: Colors.orangeAccent,
                    );
                  }),

                  const SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: -pi / 2,
            maxBlastForce: 15,
            minBlastForce: 10,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }

  Widget rewardCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 38, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}

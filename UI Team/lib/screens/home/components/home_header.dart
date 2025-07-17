import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int questionsAnswered;


  const HomeHeader({
    Key? key,
    required this.userName,
    required this.questionsAnswered,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi $userName 👋",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "9-day streak 🔥",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "5/15 questions answered today",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          )
        ],
      ),
    );
  }
}

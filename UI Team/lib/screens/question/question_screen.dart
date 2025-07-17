import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int? selectedIndex;
  int currentQuestion = 15;
  int totalQuestions = 20;

  final List<Map<String, String>> brandOptions = [
    {
      "name": "Bournvita",
      "image": "assets/images/bournvita.jpeg",
    },
    {
      "name": "Horlicks",
      "image": "assets/images/horlicks.jpeg",
    },
  ];

  void onConfirm() {
    if (selectedIndex != null) {
      String selectedBrand = brandOptions[selectedIndex!]["name"]!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You selected: $selectedBrand")),
      );
    }
  }

  void showProductDetails(String brand) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$brand Details"),
        content: const Text("Here you can add product-specific details."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ Grid Pattern Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/grid_bg2.png"), // Replace with your grid
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  // ✅ Question number capsule
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A3298),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      "QUESTION NO. - $currentQuestion",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ✅ Centered Question
                  const Text(
                    "Which is more affordable for you?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ✅ Side-by-side options with more height
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(brandOptions.length, (index) {
                      final option = brandOptions[index];
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: 300, // Increased height
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green[100] : Colors.white,
                            border: Border.all(
                              color: isSelected ? Colors.green : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                option["name"]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.green[800]
                                      : const Color(0xFF4A3298),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_downward,
                                color: Colors.blue,
                                size: 28,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  option["image"]!,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              TextButton(
                                onPressed: () => showProductDetails(option["name"]!),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFFFF7643),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: const Text("PRODUCT DETAILS"),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const Spacer(),

                  // ✅ Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalQuestions, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: index == currentQuestion - 1
                              ? const Color(0xFF4A3298)
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  // ✅ Confirm Button
                  SizedBox(
                    width: 140,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: onConfirm,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF4A3298),
                        side: const BorderSide(color: Color(0xFF4A3298), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "CONFIRM",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

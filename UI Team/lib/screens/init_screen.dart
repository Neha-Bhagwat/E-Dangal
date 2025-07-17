import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0;

  // Sample user data (you can fetch from shared prefs or backend later)
  final String userName = "Aarati";
  final int streakCount = 3;
  final int questionsAnswered = 7;
  final List<Map<String, dynamic>> selectedCategories = [
    {"name": "Fashion", "image": "assets/images/fashion.jpg"},
    {"name": "Drinks", "image": "assets/images/drinks.jpg"},
    // Add more if needed
  ];

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        userName: userName,
        questionsAnswered: questionsAnswered,
        selectedCategories: selectedCategories,
      ),
      const FavoriteScreen(),
      const Center(child: Text("Chat")),
      const ProfileScreen()
    ];

    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Shop Icon.svg",
              colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Heart Icon.svg",
              colorFilter: const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Heart Icon.svg",
              colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
            ),
            label: "Fav",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              colorFilter: const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Chat bubble Icon.svg",
              colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
            ),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(inActiveIconColor, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              colorFilter: const ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}


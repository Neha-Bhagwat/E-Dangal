import 'package:flutter/material.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/screens/question/question_screen.dart'; // ✅ Import QuestionScreen

import 'routes.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Dangal',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: {
        ...routes, // Keep your existing routes from routes.dart
        '/questionScreen': (context) => const QuestionScreen(), // ✅ Add route
      },
    );
  }
}

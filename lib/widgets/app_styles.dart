import 'package:flutter/material.dart';

class AppColors {
  static const Gradient appGradient = LinearGradient(
    colors: [Colors.deepPurple, Colors.purpleAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color iconColor = Colors.white;
  static const Color titleColor = Colors.white;
  static const Color buttonColor = Colors.blue;
  static const Color priceColor = Colors.deepOrange;
}

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    color: AppColors.titleColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle menuHeader = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
}

import 'package:flutter/material.dart';

class AppTheme {
  // Kandyan Color Palette
  static const Color kandyanCrimson = Color(0xFFB71C1C);
  static const Color kandyanGold = Color(0xFFFFA000);
  static const Color deepBrown = Color(0xFF3E2723);
  static const Color parchmentCream = Color(0xFFFFFDE7);
  static const Color softAmber = Color(0xFFFFECB3);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kandyanCrimson,
        primary: kandyanCrimson,
        secondary: kandyanGold,
        onPrimary: Colors.white,
        surface: parchmentCream,
        onSurface: deepBrown,
      ),
      scaffoldBackgroundColor: parchmentCream,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: deepBrown,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: deepBrown),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: deepBrown, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: deepBrown,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: deepBrown,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: deepBrown),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepBrown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}

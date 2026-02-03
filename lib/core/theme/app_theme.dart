import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    // Kandyan Palette: Light Yellow (Background), Deep Brown (Text/Lines), Orange (Accents)
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFFB300), // Amber/Orange
      background: const Color(0xFFFFFDE7), // Light Cream
      onBackground: const Color(0xFF3E2723), // Deep Brown
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFDE7),
    useMaterial3: true,
    fontFamily: 'Roboto', // Default fall back, can be updated later
  );
}

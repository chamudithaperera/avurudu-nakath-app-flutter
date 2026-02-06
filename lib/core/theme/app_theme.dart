import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Kandyan Color Palette
  static const Color kandyanCrimson = Color(0xFF8C1B1B);
  static const Color kandyanGold = Color(0xFFC99A3B);
  static const Color deepBrown = Color(0xFF2B1B16);
  static const Color lacquerBrown = Color(0xFF4E2A1E);
  static const Color parchmentCream = Color(0xFFF8EED1);
  static const Color softAmber = Color(0xFFF1D48E);
  static const Color warmIvory = Color(0xFFFFF7E6);

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    final textTheme = GoogleFonts.cormorantGaramondTextTheme(base.textTheme);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kandyanCrimson,
        primary: kandyanCrimson,
        secondary: kandyanGold,
        onPrimary: Colors.white,
        surface: warmIvory,
        onSurface: deepBrown,
      ),
      scaffoldBackgroundColor: warmIvory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          color: warmIvory,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: warmIvory),
      ),
      cardTheme: CardThemeData(
        color: warmIvory,
        elevation: 10,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: kandyanGold, width: 1.6),
        ),
      ),
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: warmIvory,
          letterSpacing: 1.5,
        ),
        titleLarge: GoogleFonts.cinzel(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: deepBrown,
          letterSpacing: 1.1,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          color: deepBrown,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: deepBrown,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lacquerBrown,
          foregroundColor: warmIvory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}

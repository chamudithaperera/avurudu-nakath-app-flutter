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

  static ThemeData lightThemeForLocale(Locale? locale) {
    final base = ThemeData.light();
    TextTheme textTheme =
        GoogleFonts.cormorantGaramondTextTheme(base.textTheme);
    final code = locale?.languageCode;
    if (code == 'si') {
      textTheme = textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          fontFamily: 'GemunuX',
          fontFamilyFallback: const ['Ranee', 'Anupama', 'TharuNidahasa'],
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontFamily: 'Ranee',
          fontFamilyFallback: const ['GemunuX', 'Anupama', 'TharuSansala'],
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          fontFamily: 'Anupama',
          fontFamilyFallback: const ['GemunuX', 'Ranee', 'TharuRun'],
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          fontFamily: 'Anupama',
          fontFamilyFallback: const ['GemunuX', 'Ranee', 'TharuRun'],
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontFamily: 'TharuSansala',
          fontFamilyFallback: const ['GemunuX', 'Ranee', 'Anupama'],
        ),
      );
    } else if (code == 'ta') {
      textTheme = GoogleFonts.notoSansTamilTextTheme(textTheme);
    }
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
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: warmIvory,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
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
        displayLarge: textTheme.displayLarge?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: warmIvory,
          letterSpacing: 0.6,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: deepBrown,
          letterSpacing: 0.4,
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

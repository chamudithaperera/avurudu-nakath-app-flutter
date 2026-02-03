import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avurudu Nakath App',
      theme: ThemeData(
        // Kandyan Palette: Light Yellow (Background), Deep Brown (Text/Lines), Orange (Accents)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB300), // Amber/Orange
          background: const Color(0xFFFFFDE7), // Light Cream
          onBackground: const Color(0xFF3E2723), // Deep Brown
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFDE7),
        useMaterial3: true,
        fontFamily: 'Roboto', // Default fall back, can be updated later
      ),
      home: const SplashScreen(),
    );
  }
}

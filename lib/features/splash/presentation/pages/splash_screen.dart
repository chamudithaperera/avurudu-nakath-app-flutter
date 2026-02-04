import 'package:flutter/material.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../language_selection/presentation/pages/language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sunOpacity;
  late Animation<double> _sunScale;
  late Animation<Offset> _sinhalaOffset;
  late Animation<double> _sinhalaOpacity;
  late Animation<Offset> _tamilOffset;
  late Animation<double> _tamilOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
        seconds: 4,
      ), // slightly longer for dramatic effect
      vsync: this,
    );

    // Sun Animation: Fade in and Scale up (0.0 - 0.5)
    _sunOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _sunScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    // Sinhala Text: Slide up and Fade in (0.3 - 0.7)
    _sinhalaOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
          ),
        );
    _sinhalaOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    // Tamil Text: Slide up and Fade in (0.6 - 0.9)
    _tamilOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
          ),
        );
    _tamilOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward().then((value) async {
      // Check for language selection
      final storageService = StorageService();
      final hasLanguage = await storageService.hasKey(
        StorageService.keyLanguage,
      );

      if (mounted) {
        if (hasLanguage) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LanguageSelectionScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7), // Light yellow/cream
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sun Image
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _sunOpacity.value,
                  child: Transform.scale(
                    scale: _sunScale.value,
                    child: Image.asset(
                      'assets/images/sun.png',
                      height: 180,
                      width: 180,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            // Sinhala Title
            SlideTransition(
              position: _sinhalaOffset,
              child: FadeTransition(
                opacity: _sinhalaOpacity,
                child: const Text(
                  'අපේ අවුරුදු නැකැත්', // Ape Avurudu Nakath
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723), // Deep brown
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tamil Title
            SlideTransition(
              position: _tamilOffset,
              child: FadeTransition(
                opacity: _tamilOpacity,
                child: const Text(
                  'எங்கள் புத்தாண்டு நெகத்', // Engal Puththandu Nakath
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5D4037), // Lighter brown
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

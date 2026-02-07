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
      backgroundColor: const Color(0xFFFDEE94), // Light Yellow Background
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Top Left: Sun
          Positioned(
            top: -50,
            left: -50,
            child: FadeTransition(
              opacity: _sunOpacity,
              child: Image.asset(
                'assets/images/sun.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          // Top Right: Erabadu
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset('assets/images/erabadu.png', width: 150),
          ),
          // Center Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text Section
                SlideTransition(
                  position: _sinhalaOffset,
                  child: FadeTransition(
                    opacity: _sinhalaOpacity,
                    child: Column(
                      children: [
                        Text(
                          'අපේ අවුරුදු නැකත්',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'KDNAMAL', // Fallback for 4u-Nisansala
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFFD700), // Yellowish fill
                            shadows: [
                              Shadow(
                                // Black outline effect
                                offset: const Offset(-1.5, -1.5),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: const Offset(1.5, -1.5),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: const Offset(1.5, 1.5),
                                color: Colors.black,
                              ),
                              Shadow(
                                offset: const Offset(-1.5, 1.5),
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'எங்கள் புத்தாண்டு நெகத்',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Main Illustration (Pot/Family)
                ScaleTransition(
                  scale: _sunScale, // Reusing scale animation
                  child: Image.asset(
                    'assets/images/pot.png', // Placeholder for family
                    height: 250,
                  ),
                ),
              ],
            ),
          ),
          // Bottom Left: Kiribath
          Positioned(
            bottom: 20,
            left: -20,
            child: Image.asset('assets/images/Kiribath.png', width: 120),
          ),
          // Bottom Center: Pancha
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/panchagame.png', width: 150),
            ),
          ),
          // Bottom Right: Sweets
          Positioned(
            bottom: 20,
            right: -20,
            child: Image.asset('assets/images/sweets.png', width: 120),
          ),
        ],
      ),
    );
  }
}

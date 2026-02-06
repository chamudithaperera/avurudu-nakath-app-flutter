import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../language_selection/presentation/pages/language_selection_screen.dart';
import '../../../../core/widgets/kandyan_background.dart';

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
      body: KandyanBackground(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _sunOpacity.value,
                    child: Transform.scale(
                      scale: _sunScale.value,
                      child: Transform.rotate(
                        angle: _controller.value * 0.2,
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFC99A3B),
                              width: 2.5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/lotus_mandala.png',
                            height: 190,
                            width: 190,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8EED1).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFC99A3B),
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SlideTransition(
                      position: _sinhalaOffset,
                      child: FadeTransition(
                        opacity: _sinhalaOpacity,
                        child: Text(
                          'අපේ අවුරුදු නැකැත්',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansSinhala(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2B1B16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideTransition(
                      position: _tamilOffset,
                      child: FadeTransition(
                        opacity: _tamilOpacity,
                        child: Text(
                          'எங்கள் புத்தாண்டு நெகத்',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansTamil(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4E2A1E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

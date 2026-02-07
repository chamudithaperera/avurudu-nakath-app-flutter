import 'package:flutter/material.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/datasources/language_local_data_source.dart';
import '../../data/repositories/language_repository_impl.dart';
import '../../domain/repositories/language_repository.dart';
import '../../../home/presentation/pages/home_screen.dart';
import 'package:avurudu_nakath_app/main.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  late LanguageRepository _repository;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Dependency Injection (Manual for now)
    final storageService = StorageService();
    final localDataSource = LanguageLocalDataSourceImpl(
      storageService: storageService,
    );
    _repository = LanguageRepositoryImpl(localDataSource: localDataSource);

    // Animation Setup
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectLanguage(String code) async {
    await _repository.setLanguage(code);
    if (mounted) {
      MyApp.setLocale(context, Locale(code));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
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
            top: -60,
            left: -60,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Opacity(
                opacity: 0.9,
                child: Image.asset(
                  'assets/images/sun.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          // Top Right: Erabadu
          Positioned(
            top: -20,
            right: -20,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset('assets/images/erabadu.png', width: 150),
              ),
            ),
          ),
          // Center Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Family Image
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Image.asset(
                          'assets/images/splash cover.png',
                          height: 180,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Content Slide Setup
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            // Sinhala Title
                            Text(
                              'ඔබගේ භාෂාව තෝරන්න',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'KDNAMAL',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4E342E), // Dark Brown
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Tamil Title
                            Text(
                              'உங்கள் மொழியைத் தேர்வுசெய்யவும்',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(
                                  0xFF5D4037,
                                ), // Slightly lighter brown
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Sinhala Button
                            _buildLanguageButton(
                              label: 'සිංහල',
                              fontFamily: 'TharuRun',
                              onTap: () => _selectLanguage('si'),
                            ),
                            const SizedBox(height: 16),

                            // Tamil Button
                            _buildLanguageButton(
                              label: 'தமிழ்',
                              // Removed TharuRun as it's likely a Sinhala font
                              onTap: () => _selectLanguage('ta'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Left: Kiribath
          Positioned(
            bottom: 0,
            left: -10,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset('assets/images/Kiribath.png', width: 120),
              ),
            ),
          ),
          // Bottom Center: Pancha
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Opacity(
                  opacity: 0.8,
                  child: Image.asset(
                    'assets/images/panchagame.png',
                    width: 130,
                  ),
                ),
              ),
            ),
          ),
          // Bottom Right: Sweets
          Positioned(
            bottom: 0,
            right: -10,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset('assets/images/sweets.png', width: 120),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required String label,
    required VoidCallback onTap,
    String? fontFamily,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107), // Amber
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

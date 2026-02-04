import 'package:flutter/material.dart';
import '../../../../core/services/storage_service.dart';
import '../../data/datasources/language_local_data_source.dart';
import '../../data/repositories/language_repository_impl.dart';
import '../../domain/repositories/language_repository.dart';
import '../widgets/language_button.dart';
import '../../../home/presentation/pages/home_screen.dart';
import 'package:avurudu_nakath_app/main.dart';
import 'package:avurudu_nakath_app/l10n/generated/ui/ui_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late LanguageRepository _repository;

  @override
  void initState() {
    super.initState();
    // Dependency Injection (Manual for now)
    final storageService = StorageService();
    final localDataSource = LanguageLocalDataSourceImpl(
      storageService: storageService,
    );
    _repository = LanguageRepositoryImpl(localDataSource: localDataSource);
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
    final uiL10n = UiLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Parchment Texture Base
          Positioned.fill(
            child: Image.asset(
              'assets/images/parchment_texture.png',
              fit: BoxFit.cover,
            ),
          ),

          // Background Mandala
          Positioned(
            bottom: -50,
            right: -50,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('assets/images/lotus_mandala.png', width: 300),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Hero Mandala
                  Image.asset(
                    'assets/images/lotus_mandala.png',
                    height: 140,
                    width: 140,
                  ),
                  const SizedBox(height: 48),
                  Text(
                    uiL10n.selectLanguage.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    uiL10n.pleaseSelectLanguage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Sinhala Button
                  LanguageButton(
                    label: 'සිංහල',
                    subLabel: 'Sinhala',
                    onTap: () => _selectLanguage('si'),
                  ),
                  const SizedBox(height: 16),
                  // Tamil Button
                  LanguageButton(
                    label: 'தமிழ்',
                    subLabel: 'Tamil',
                    onTap: () => _selectLanguage('ta'),
                  ),

                  const Spacer(),
                  // Decorative Liyawela
                  Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/images/liyawela_border.png',
                      height: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

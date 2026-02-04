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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo Placeholder (Sun)
              Image.asset('assets/images/sun.png', height: 120, width: 120),
              const SizedBox(height: 40),
              Text(
                uiL10n.selectLanguage,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                uiL10n.pleaseSelectLanguage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 60),

              // Sinhala Button
              LanguageButton(
                label: 'සිංහල',
                subLabel: 'Sinhala',
                onTap: () => _selectLanguage('si'),
              ),

              // Tamil Button
              LanguageButton(
                label: 'தமிழ்',
                subLabel: 'Tamil',
                onTap: () => _selectLanguage('ta'),
              ),

              const Spacer(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

import '../datasources/language_local_data_source.dart';
import '../../domain/repositories/language_repository.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDataSource localDataSource;

  LanguageRepositoryImpl({required this.localDataSource});

  @override
  Future<void> setLanguage(String languageCode) async {
    await localDataSource.cacheLanguageCode(languageCode);
  }

  @override
  Future<String?> getLanguage() async {
    return await localDataSource.getCachedLanguageCode();
  }
}

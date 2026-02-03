import '../../../../core/services/storage_service.dart';

abstract class LanguageLocalDataSource {
  Future<void> cacheLanguageCode(String languageCode);
  Future<String?> getCachedLanguageCode();
}

class LanguageLocalDataSourceImpl implements LanguageLocalDataSource {
  final StorageService storageService;

  LanguageLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> cacheLanguageCode(String languageCode) async {
    await storageService.saveString(StorageService.keyLanguage, languageCode);
  }

  @override
  Future<String?> getCachedLanguageCode() async {
    return await storageService.getString(StorageService.keyLanguage);
  }
}

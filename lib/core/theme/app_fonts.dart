import 'package:flutter/widgets.dart';

class AppFonts {
  static const String sinhalaUi = 'NotoSansSinhala';
  static const String kandyanDisplay = 'KDNAMAL';

  static bool isSinhala(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'si';
  }

  static String? localeAwareTextFamily(BuildContext context) {
    return isSinhala(context) ? sinhalaUi : null;
  }
}

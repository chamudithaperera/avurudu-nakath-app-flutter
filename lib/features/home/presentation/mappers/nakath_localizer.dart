import 'package:flutter/widgets.dart';
import 'package:avurudu_nakath_app/l10n/generated/nakath/nakath_localizations.dart';
import '../../domain/entities/nakath_event.dart';

extension NakathEventLocalization on NakathEvent {
  String getLocalizedTitle(BuildContext context) {
    final l10n = NakathLocalizations.of(context);
    if (l10n == null) return titleKey;

    switch (titleKey) {
      case 'nakath_newMoon_title':
        return l10n.nakath_newMoon_title;
      case 'nakath_bathingLastYear_title':
        return l10n.nakath_bathingLastYear_title;
      case 'nakath_punyaKalaya_title':
        return l10n.nakath_punyaKalaya_title;
      case 'nakath_newYearDawn_title':
        return l10n.nakath_newYearDawn_title;
      case 'nakath_cookingFood_title':
        return l10n.nakath_cookingFood_title;
      case 'nakath_eatingWorking_title':
        return l10n.nakath_eatingWorking_title;
      case 'nakath_anointingOil_title':
        return l10n.nakath_anointingOil_title;
      case 'nakath_leavingForWork_title':
        return l10n.nakath_leavingForWork_title;
      default:
        return titleKey;
    }
  }

  String getLocalizedDescription(BuildContext context) {
    final l10n = NakathLocalizations.of(context);
    if (l10n == null) return descriptionKey;

    switch (descriptionKey) {
      case 'nakath_newMoon_desc':
        return l10n.nakath_newMoon_desc;
      case 'nakath_bathingLastYear_desc':
        return l10n.nakath_bathingLastYear_desc;
      case 'nakath_punyaKalaya_desc':
        return l10n.nakath_punyaKalaya_desc;
      case 'nakath_newYearDawn_desc':
        return l10n.nakath_newYearDawn_desc;
      case 'nakath_cookingFood_desc':
        return l10n.nakath_cookingFood_desc;
      case 'nakath_eatingWorking_desc':
        return l10n.nakath_eatingWorking_desc;
      case 'nakath_anointingOil_desc':
        return l10n.nakath_anointingOil_desc;
      case 'nakath_leavingForWork_desc':
        return l10n.nakath_leavingForWork_desc;
      default:
        return descriptionKey;
    }
  }
}

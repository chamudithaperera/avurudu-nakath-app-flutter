import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'nakath_localizations_en.dart';
import 'nakath_localizations_si.dart';
import 'nakath_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of NakathLocalizations
/// returned by `NakathLocalizations.of(context)`.
///
/// Applications need to include `NakathLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'nakath/nakath_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: NakathLocalizations.localizationsDelegates,
///   supportedLocales: NakathLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the NakathLocalizations.supportedLocales
/// property.
abstract class NakathLocalizations {
  NakathLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static NakathLocalizations? of(BuildContext context) {
    return Localizations.of<NakathLocalizations>(context, NakathLocalizations);
  }

  static const LocalizationsDelegate<NakathLocalizations> delegate = _NakathLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @nakath_newMoon_title.
  ///
  /// In si, this message translates to:
  /// **'නව සඳ බැලීම'**
  String get nakath_newMoon_title;

  /// No description provided for @nakath_newMoon_desc.
  ///
  /// In si, this message translates to:
  /// **'අභිනව චන්ද්‍ර වර්ෂය සඳහා මාර්තු මස 30 වැනි ඉරිදා දින ද අභිනව සූර්ය වර්ෂය සඳහා අප්‍රේල් මස 01 වැනි අඟහරුවාදා දින ද නව සඳ බැලීම මැනවි.'**
  String get nakath_newMoon_desc;

  /// No description provided for @nakath_bathingLastYear_title.
  ///
  /// In si, this message translates to:
  /// **'පරණ අවුරුද්ද සඳහා ස්නානය'**
  String get nakath_bathingLastYear_title;

  /// No description provided for @nakath_bathingLastYear_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 12 වැනි සෙනසුරාදා දින නුග පත් යුෂ මිශ්‍ර නානු ගා ස්නානය කොට ඉෂ්ඨ දේවතා අනුස්මරණයෙහි යෙදී වාසය කිරීම මැනවි.'**
  String get nakath_bathingLastYear_desc;

  /// No description provided for @nakath_punyaKalaya_title.
  ///
  /// In si, this message translates to:
  /// **'පුන්‍ය කාලය'**
  String get nakath_punyaKalaya_title;

  /// No description provided for @nakath_punyaKalaya_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 13 වැනි ඉරිදා රාත්‍රී 08.57 සිට පසුදින (14) පෙරවරු 09.45 දක්වා පුන්‍ය කාලය බැවින්, අප්‍රේල් මස 13 වැනි ඉරිදා රාත්‍රී 08.57 ට පෙර ආහාර පාන ගෙන සියලු වැඩ අතහැර ආගමික වතාවත්වල යෙදීම ද, පුන්‍ය කාලයේ අපර කොටස වන අප්‍රේල් මස 14 වැනි සඳුදා අලුයම 02.21 සිට පෙරවරු 09.45 දක්වා පහත දැක්වෙන අයුරින් වැඩ අල්ලීම, ගනුදෙනු කිරීම හා ආහාර අනුභවය ආදී චාරිත්‍ර විධි ඉටු කිරීම මැනවි.'**
  String get nakath_punyaKalaya_desc;

  /// No description provided for @nakath_newYearDawn_title.
  ///
  /// In si, this message translates to:
  /// **'අවුරුදු උදාව'**
  String get nakath_newYearDawn_title;

  /// No description provided for @nakath_newYearDawn_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 14 වැනි සඳුදා අලුයම 02.21 ට සිංහල අලුත් අවුරුද්ද උදා වේ.'**
  String get nakath_newYearDawn_desc;

  /// No description provided for @nakath_cookingFood_title.
  ///
  /// In si, this message translates to:
  /// **'ආහාර පිසීම'**
  String get nakath_cookingFood_title;

  /// No description provided for @nakath_cookingFood_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 14 වැනි සඳුදා අලුයම 03.54 ට ධවල වර්ණ වස්ත්‍රාභරණයෙන් සැරසී දකුණු දිශාව බලා ලිප් බැඳ ගිනි මොළවා දී කිරි සහ කිතුල් හකුරු මිශ්‍ර කිරිබතක් ද, තල සහ විලඳ මිශ්‍ර කැවිලි වර්ගයක් ද පිළියෙල කරගැනීම මැනවි.'**
  String get nakath_cookingFood_desc;

  /// No description provided for @nakath_eatingWorking_title.
  ///
  /// In si, this message translates to:
  /// **'වැඩ ඇල්ලීම, ගනුදෙනු කිරීම හා ආහාර අනුභවය'**
  String get nakath_eatingWorking_title;

  /// No description provided for @nakath_eatingWorking_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 14 වැනි සඳුදා අලුයම 04.29 ට ධවල වර්ණ වස්ත්‍රාභරණයෙන් සැරසී දකුණු දිශාව බලා සියලු වැඩ අල්ලා ගනුදෙනු කොට ආහාර අනුභවය මැනවි.'**
  String get nakath_eatingWorking_desc;

  /// No description provided for @nakath_anointingOil_title.
  ///
  /// In si, this message translates to:
  /// **'හිස තෙල් ගෑම'**
  String get nakath_anointingOil_title;

  /// No description provided for @nakath_anointingOil_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 16 වැනි බදාදා පෙරවරු 09.41 ට කොළ පැහැති වස්ත්‍රාභරණයෙන් සැරසී නැගෙනහිර දිශාව බලා හිසට කොහොඹ පත් ද පයට කොලොන් පත් ද තබා කොහොඹ පත් යුෂ මිශ්‍ර නානු හා තෙල් ගෑම මැනවි.'**
  String get nakath_anointingOil_desc;

  /// No description provided for @nakath_leavingForWork_title.
  ///
  /// In si, this message translates to:
  /// **'රැකිරක්ෂා සඳහා පිටත්ව යෑම'**
  String get nakath_leavingForWork_title;

  /// No description provided for @nakath_leavingForWork_desc.
  ///
  /// In si, this message translates to:
  /// **'අප්‍රේල් මස 17 වැනි බ්‍රහස්පතින්දා පෙරවරු 06.28 ට රන්වන් පැහැති වස්ත්‍රාභරණයෙන් සැරසී හකුරු මිශ්‍ර කිරිබතක් අනුභව කර නැගෙනහිර දිශාව බලා පිටත්ව යෑම මැනවි.'**
  String get nakath_leavingForWork_desc;

  /// No description provided for @notification_5min_suffix.
  ///
  /// In si, this message translates to:
  /// **' නැකැතට තව මිනිත්තු 5යි.'**
  String get notification_5min_suffix;

  /// No description provided for @notification_ontime_prefix.
  ///
  /// In si, this message translates to:
  /// **'දැන් '**
  String get notification_ontime_prefix;

  /// No description provided for @notification_ontime_suffix.
  ///
  /// In si, this message translates to:
  /// **' නැකැතයි.'**
  String get notification_ontime_suffix;

  /// No description provided for @notification_today_suffix.
  ///
  /// In si, this message translates to:
  /// **' නැකැත අදයි.'**
  String get notification_today_suffix;
}

class _NakathLocalizationsDelegate extends LocalizationsDelegate<NakathLocalizations> {
  const _NakathLocalizationsDelegate();

  @override
  Future<NakathLocalizations> load(Locale locale) {
    return SynchronousFuture<NakathLocalizations>(lookupNakathLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_NakathLocalizationsDelegate old) => false;
}

NakathLocalizations lookupNakathLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return NakathLocalizationsEn();
    case 'si': return NakathLocalizationsSi();
    case 'ta': return NakathLocalizationsTa();
  }

  throw FlutterError(
    'NakathLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

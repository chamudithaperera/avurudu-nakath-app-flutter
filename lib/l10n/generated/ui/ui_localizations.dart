import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'ui_localizations_si.dart';
import 'ui_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of UiLocalizations
/// returned by `UiLocalizations.of(context)`.
///
/// Applications need to include `UiLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'ui/ui_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: UiLocalizations.localizationsDelegates,
///   supportedLocales: UiLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the UiLocalizations.supportedLocales
/// property.
abstract class UiLocalizations {
  UiLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static UiLocalizations? of(BuildContext context) {
    return Localizations.of<UiLocalizations>(context, UiLocalizations);
  }

  static const LocalizationsDelegate<UiLocalizations> delegate = _UiLocalizationsDelegate();

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
    Locale('si'),
    Locale('ta')
  ];

  /// No description provided for @appTitle.
  ///
  /// In si, this message translates to:
  /// **'අපේ අවුරුදු නැකැත්'**
  String get appTitle;

  /// No description provided for @nextUpcoming.
  ///
  /// In si, this message translates to:
  /// **'ඊළඟ නැකත'**
  String get nextUpcoming;

  /// No description provided for @allNakath.
  ///
  /// In si, this message translates to:
  /// **'සියලුම නැකැත්'**
  String get allNakath;

  /// No description provided for @close.
  ///
  /// In si, this message translates to:
  /// **'වහන්න'**
  String get close;

  /// No description provided for @selectLanguage.
  ///
  /// In si, this message translates to:
  /// **'භාෂාව තෝරන්න'**
  String get selectLanguage;

  /// No description provided for @pleaseSelectLanguage.
  ///
  /// In si, this message translates to:
  /// **'කරුණාකර ඔබ කැමති භාෂාව තෝරන්න'**
  String get pleaseSelectLanguage;

  /// No description provided for @english.
  ///
  /// In si, this message translates to:
  /// **'ඉංග්‍රීසි'**
  String get english;

  /// No description provided for @sinhala.
  ///
  /// In si, this message translates to:
  /// **'සිංහල'**
  String get sinhala;

  /// No description provided for @tamil.
  ///
  /// In si, this message translates to:
  /// **'දෙමළ'**
  String get tamil;

  /// No description provided for @days.
  ///
  /// In si, this message translates to:
  /// **'දින'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In si, this message translates to:
  /// **'පැය'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In si, this message translates to:
  /// **'මිනිත්තු'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In si, this message translates to:
  /// **'තත්පර'**
  String get seconds;

  /// No description provided for @drawerNotificationsTitle.
  ///
  /// In si, this message translates to:
  /// **'දැනුම්දීම්'**
  String get drawerNotificationsTitle;

  /// No description provided for @drawerNotificationsSubtitle.
  ///
  /// In si, this message translates to:
  /// **'කාලයට හා මිනිත්තු 5කට පෙර මතක් කරයි'**
  String get drawerNotificationsSubtitle;

  /// No description provided for @drawerChangeLanguage.
  ///
  /// In si, this message translates to:
  /// **'භාෂාව වෙනස් කරන්න'**
  String get drawerChangeLanguage;

  /// No description provided for @drawerAbout.
  ///
  /// In si, this message translates to:
  /// **'අපේ ගැන'**
  String get drawerAbout;

  /// No description provided for @drawerAboutBody.
  ///
  /// In si, this message translates to:
  /// **'සිංහල සහ දෙමළ අලුත් අවුරුදු නැකැත් සඳහා දේශීය දැනුම්දීම්.\n\nA Product of ChamXdev by Chamuditha Perera\n© Avurudu Nakath App - 2026'**
  String get drawerAboutBody;
}

class _UiLocalizationsDelegate extends LocalizationsDelegate<UiLocalizations> {
  const _UiLocalizationsDelegate();

  @override
  Future<UiLocalizations> load(Locale locale) {
    return SynchronousFuture<UiLocalizations>(lookupUiLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['si', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_UiLocalizationsDelegate old) => false;
}

UiLocalizations lookupUiLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'si': return UiLocalizationsSi();
    case 'ta': return UiLocalizationsTa();
  }

  throw FlutterError(
    'UiLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

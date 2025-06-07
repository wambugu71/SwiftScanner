import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('sw'),
    Locale('ta'),
    Locale('zh'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Swift Scan'**
  String get appTitle;

  /// Navigation label for scan tab
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScan;

  /// Navigation label for history tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// Navigation label for generate tab
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get navGenerate;

  /// Navigation label for settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Navigation label for about tab
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// Title for the home page
  ///
  /// In en, this message translates to:
  /// **'QR Code Scanner'**
  String get homeTitle;

  /// Instruction text on home page
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a QR code to scan it'**
  String get homeInstruction;

  /// Flash on button text
  ///
  /// In en, this message translates to:
  /// **'Flash On'**
  String get homeFlashOn;

  /// Flash off button text
  ///
  /// In en, this message translates to:
  /// **'Flash Off'**
  String get homeFlashOff;

  /// Switch camera button text
  ///
  /// In en, this message translates to:
  /// **'Switch Camera'**
  String get homeSwitchCamera;

  /// Select image button text
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get homeSelectImage;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Haptic feedback setting label
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get settingsHapticFeedback;

  /// Haptic feedback setting description
  ///
  /// In en, this message translates to:
  /// **'Vibrate when QR code is detected'**
  String get settingsHapticFeedbackDesc;

  /// Welcome message on intro page
  ///
  /// In en, this message translates to:
  /// **'Welcome to Swift Scan'**
  String get introWelcome;

  /// First intro page title
  ///
  /// In en, this message translates to:
  /// **'Scan QR Codes'**
  String get introTitle1;

  /// First intro page description
  ///
  /// In en, this message translates to:
  /// **'Quickly scan any QR code using your camera with lightning fast detection'**
  String get introDesc1;

  /// Second intro page title
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get introTitle2;

  /// Second intro page description
  ///
  /// In en, this message translates to:
  /// **'Keep track of all your scanned codes and access them anytime'**
  String get introDesc2;

  /// Third intro page title
  ///
  /// In en, this message translates to:
  /// **'Share & Save'**
  String get introTitle3;

  /// Third intro page description
  ///
  /// In en, this message translates to:
  /// **'Copy, share, or open scanned content with just a tap'**
  String get introDesc3;

  /// Next button text on intro page
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get introNext;

  /// Get started button text on intro page
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get introGetStarted;

  /// About page title
  ///
  /// In en, this message translates to:
  /// **'About Swift Scan'**
  String get aboutTitle;

  /// Version label on about page
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutVersion;

  /// App description on about page
  ///
  /// In en, this message translates to:
  /// **'Swift Scan is a powerful and intuitive QR code scanner that makes scanning codes faster and easier than ever. Built with modern technology to provide lightning-fast detection and a seamless user experience.'**
  String get aboutDescription;

  /// Features section title on about page
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get aboutFeatures;

  /// First feature description
  ///
  /// In en, this message translates to:
  /// **'Lightning-fast QR code detection'**
  String get aboutFeature1;

  /// Second feature description
  ///
  /// In en, this message translates to:
  /// **'Support for multiple QR code formats'**
  String get aboutFeature2;

  /// Third feature description
  ///
  /// In en, this message translates to:
  /// **'Scan history with easy access'**
  String get aboutFeature3;

  /// Fourth feature description
  ///
  /// In en, this message translates to:
  /// **'Share and save scanned content'**
  String get aboutFeature4;

  /// Fifth feature description
  ///
  /// In en, this message translates to:
  /// **'Dark and light theme support'**
  String get aboutFeature5;

  /// Sixth feature description
  ///
  /// In en, this message translates to:
  /// **'Multiple language support'**
  String get aboutFeature6;

  /// Developer section title
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloper;

  /// Developer name
  ///
  /// In en, this message translates to:
  /// **'Swift Scan Team'**
  String get aboutDeveloperName;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get aboutContact;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get aboutEmail;

  /// Website label
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get aboutWebsite;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacy;

  /// Terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get aboutTerms;

  /// Open source licenses link
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutLicenses;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'fr',
    'sw',
    'ta',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

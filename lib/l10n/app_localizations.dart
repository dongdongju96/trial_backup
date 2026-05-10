import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Eye Lock Challenge'**
  String get appTitle;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Focus. Hold. Beat your time.'**
  String get splashTagline;

  /// No description provided for @chooseChallengeMode.
  ///
  /// In en, this message translates to:
  /// **'Choose a challenge mode'**
  String get chooseChallengeMode;

  /// No description provided for @modeSelectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep your gaze locked on the highlighted eye area as long as you can.'**
  String get modeSelectionDescription;

  /// No description provided for @maleMode.
  ///
  /// In en, this message translates to:
  /// **'Male Mode'**
  String get maleMode;

  /// No description provided for @femaleMode.
  ///
  /// In en, this message translates to:
  /// **'Female Mode'**
  String get femaleMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectionTitle;

  /// No description provided for @languageSelectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used in the app.'**
  String get languageSelectionDescription;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// No description provided for @cameraPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera permission'**
  String get cameraPermissionTitle;

  /// No description provided for @cameraPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'This app uses the front camera only to estimate your gaze during the game. Camera images are not saved, recorded, or uploaded. All processing happens on your device.'**
  String get cameraPermissionDescription;

  /// No description provided for @privacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Camera images are processed only on your device and are never saved or uploaded.'**
  String get privacyNotice;

  /// No description provided for @startChallenge.
  ///
  /// In en, this message translates to:
  /// **'Start challenge'**
  String get startChallenge;

  /// No description provided for @allowCamera.
  ///
  /// In en, this message translates to:
  /// **'Allow camera'**
  String get allowCamera;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting...'**
  String get requesting;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @cameraDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to play the gaze challenge.'**
  String get cameraDeniedMessage;

  /// No description provided for @cameraPermanentlyDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is blocked. Please enable camera access in system settings.'**
  String get cameraPermanentlyDeniedMessage;

  /// No description provided for @preparingChallenge.
  ///
  /// In en, this message translates to:
  /// **'Preparing the challenge...'**
  String get preparingChallenge;

  /// No description provided for @countdownInstruction.
  ///
  /// In en, this message translates to:
  /// **'Focus on the highlighted eye area.'**
  String get countdownInstruction;

  /// No description provided for @mockTrackingActive.
  ///
  /// In en, this message translates to:
  /// **'Mock gaze tracking is active. The full camera pipeline comes next.'**
  String get mockTrackingActive;

  /// No description provided for @gazeMovedAway.
  ///
  /// In en, this message translates to:
  /// **'Gaze moved away.'**
  String get gazeMovedAway;

  /// No description provided for @savingResult.
  ///
  /// In en, this message translates to:
  /// **'Saving result...'**
  String get savingResult;

  /// No description provided for @cameraUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera preview unavailable. Using mock frames.'**
  String get cameraUnavailableMessage;

  /// No description provided for @cameraStreamUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera stream unavailable. Using mock frames.'**
  String get cameraStreamUnavailableMessage;

  /// No description provided for @noFaceDetectedMessage.
  ///
  /// In en, this message translates to:
  /// **'No face detected. Keep your face visible to the front camera.'**
  String get noFaceDetectedMessage;

  /// No description provided for @noEyesDetectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Eyes not detected clearly. Move closer or improve lighting.'**
  String get noEyesDetectedMessage;

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @resultDurationIntro.
  ///
  /// In en, this message translates to:
  /// **'You kept eye contact for:'**
  String get resultDurationIntro;

  /// No description provided for @resultDurationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String resultDurationSeconds(String seconds);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @backToModeSelection.
  ///
  /// In en, this message translates to:
  /// **'Mode selection'**
  String get backToModeSelection;

  /// No description provided for @timerSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String timerSeconds(String seconds);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

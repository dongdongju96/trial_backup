// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Eye Lock Challenge';

  @override
  String get splashTagline => 'Focus. Hold. Beat your time.';

  @override
  String get chooseChallengeMode => 'Choose a challenge mode';

  @override
  String get modeSelectionDescription =>
      'Keep your gaze locked on the highlighted eye area as long as you can.';

  @override
  String get maleMode => 'Male Mode';

  @override
  String get femaleMode => 'Female Mode';

  @override
  String get language => 'Language';

  @override
  String get languageSelectionTitle => 'Language';

  @override
  String get languageSelectionDescription =>
      'Choose the language used in the app.';

  @override
  String get english => 'English';

  @override
  String get korean => 'Korean';

  @override
  String get cameraPermissionTitle => 'Camera permission';

  @override
  String get cameraPermissionDescription =>
      'This app uses the front camera only to estimate your gaze during the game. Camera images are not saved, recorded, or uploaded. All processing happens on your device.';

  @override
  String get privacyNotice =>
      'Camera images are processed only on your device and are never saved or uploaded.';

  @override
  String get startChallenge => 'Start challenge';

  @override
  String get allowCamera => 'Allow camera';

  @override
  String get requesting => 'Requesting...';

  @override
  String get openSettings => 'Open settings';

  @override
  String get cameraDeniedMessage =>
      'Camera permission is required to play the gaze challenge.';

  @override
  String get cameraPermanentlyDeniedMessage =>
      'Camera permission is blocked. Please enable camera access in system settings.';

  @override
  String get preparingChallenge => 'Preparing the challenge...';

  @override
  String get countdownInstruction => 'Focus on the highlighted eye area.';

  @override
  String get mockTrackingActive =>
      'Mock gaze tracking is active. The full camera pipeline comes next.';

  @override
  String get gazeMovedAway => 'Gaze moved away.';

  @override
  String get savingResult => 'Saving result...';

  @override
  String get cameraUnavailableMessage =>
      'Camera preview unavailable. Using mock frames.';

  @override
  String get cameraStreamUnavailableMessage =>
      'Camera stream unavailable. Using mock frames.';

  @override
  String get noFaceDetectedMessage =>
      'No face detected. Keep your face visible to the front camera.';

  @override
  String get noEyesDetectedMessage =>
      'Eyes not detected clearly. Move closer or improve lighting.';

  @override
  String get gameOver => 'Game Over';

  @override
  String get resultDurationIntro => 'You kept eye contact for:';

  @override
  String resultDurationSeconds(String seconds) {
    return '$seconds seconds';
  }

  @override
  String get retry => 'Retry';

  @override
  String get backToModeSelection => 'Mode selection';

  @override
  String timerSeconds(String seconds) {
    return '$seconds s';
  }
}

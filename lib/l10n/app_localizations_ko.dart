// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '아이 락 챌린지';

  @override
  String get splashTagline => '집중하고, 버티고, 기록을 깨보세요.';

  @override
  String get chooseChallengeMode => '챌린지 모드 선택';

  @override
  String get modeSelectionDescription => '강조된 눈 영역을 최대한 오래 바라보세요.';

  @override
  String get maleMode => '남성 모드';

  @override
  String get femaleMode => '여성 모드';

  @override
  String get language => '언어';

  @override
  String get languageSelectionTitle => '언어';

  @override
  String get languageSelectionDescription => '앱에서 사용할 언어를 선택하세요.';

  @override
  String get english => '영어';

  @override
  String get korean => '한국어';

  @override
  String get cameraPermissionTitle => '카메라 권한';

  @override
  String get cameraPermissionDescription =>
      '이 앱은 게임 중 시선 추정을 위해서만 전면 카메라를 사용합니다. 카메라 이미지는 저장, 녹화 또는 업로드되지 않습니다. 모든 처리는 기기에서만 이루어집니다.';

  @override
  String get privacyNotice => '카메라 이미지는 기기에서만 실시간 처리되며 저장되거나 업로드되지 않습니다.';

  @override
  String get startChallenge => '챌린지 시작';

  @override
  String get allowCamera => '카메라 허용';

  @override
  String get requesting => '요청 중...';

  @override
  String get openSettings => '설정 열기';

  @override
  String get cameraDeniedMessage => '시선 챌린지를 플레이하려면 카메라 권한이 필요합니다.';

  @override
  String get cameraPermanentlyDeniedMessage =>
      '카메라 권한이 차단되어 있습니다. 시스템 설정에서 카메라 접근을 허용해주세요.';

  @override
  String get preparingChallenge => '챌린지를 준비하는 중...';

  @override
  String get countdownInstruction => '강조된 눈 영역을 바라보세요.';

  @override
  String get mockTrackingActive =>
      'Mock 시선 추적이 실행 중입니다. 실제 카메라 파이프라인은 다음 단계에서 연결됩니다.';

  @override
  String get gazeMovedAway => '시선이 벗어났습니다.';

  @override
  String get savingResult => '결과를 저장하는 중...';

  @override
  String get cameraUnavailableMessage =>
      '카메라 미리보기를 사용할 수 없습니다. Mock 프레임을 사용합니다.';

  @override
  String get cameraStreamUnavailableMessage =>
      '카메라 스트림을 사용할 수 없습니다. Mock 프레임을 사용합니다.';

  @override
  String get noFaceDetectedMessage => '얼굴이 감지되지 않았습니다. 전면 카메라에 얼굴이 보이도록 해주세요.';

  @override
  String get noEyesDetectedMessage =>
      '눈이 선명하게 감지되지 않았습니다. 조금 더 가까이 가거나 조명을 밝게 해주세요.';

  @override
  String get gameOver => '게임 종료';

  @override
  String get resultDurationIntro => '눈 맞춤을 유지한 시간:';

  @override
  String resultDurationSeconds(String seconds) {
    return '$seconds초';
  }

  @override
  String get retry => '다시 하기';

  @override
  String get backToModeSelection => '모드 선택';

  @override
  String timerSeconds(String seconds) {
    return '$seconds초';
  }
}

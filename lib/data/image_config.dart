import 'package:flutter/material.dart';

import '../models/game_mode.dart';
import '../models/target_area.dart';
import '../utils/constants.dart';

/// One source of truth for the image used by each challenge mode.
///
/// GameScreen receives this single object and passes the same [imagePath] and
/// [targetArea] to the masked countdown view and the revealed gameplay view.
/// That prevents the countdown from highlighting one eye area while gameplay
/// accidentally uses a different image or rectangle.
class GameImageConfig {
  const GameImageConfig({
    required this.mode,
    required this.imagePath,
    required this.targetArea,
    required this.fallbackDisplayLabel,
    required this.placeholderGradientColors,
  });

  final GameMode mode;

  /// Asset path for the portrait image shown during the challenge.
  ///
  /// Real licensed images can replace these placeholder paths later without
  /// changing GameScreen or GameController.
  final String imagePath;

  /// Normalized rectangle around the target eye area.
  final TargetArea targetArea;

  /// Non-localized fallback label for debugging or logs.
  ///
  /// Visible UI labels still come from AppLocalizations.
  final String fallbackDisplayLabel;

  /// Colors used by placeholder art when the real image asset is not present.
  final List<Color> placeholderGradientColors;
}

class ImageConfig {
  const ImageConfig._();

  static const String koreanMaleImagePath = 'assets/images/game/ko_male.png';
  static const String koreanFemaleImagePath =
      'assets/images/game/ko_female.png';
  static const String englishMaleImagePath = 'assets/images/game/en_male.png';
  static const String englishFemaleImagePath =
      'assets/images/game/en_female.png';

  static const GameImageConfig koreanMale = GameImageConfig(
    mode: GameMode.male,
    imagePath: koreanMaleImagePath,
    fallbackDisplayLabel: 'Male Mode',
    // The values are normalized: x/y/width/height are percentages of the image.
    // For example, x: 0.26 means "start 26% from the left edge".
    targetArea: TargetArea(x: 0.24, y: 0.235, width: 0.43, height: 0.10),
    placeholderGradientColors: [
      AppColors.surface,
      AppColors.portraitMaleGradientEnd,
    ],
  );

  static const GameImageConfig koreanFemale = GameImageConfig(
    mode: GameMode.female,
    imagePath: koreanFemaleImagePath,
    fallbackDisplayLabel: 'Female Mode',
    targetArea: TargetArea(x: 0.25, y: 0.27, width: 0.42, height: 0.10),
    placeholderGradientColors: [
      AppColors.surface,
      AppColors.portraitFemaleGradientEnd,
    ],
  );

  static const GameImageConfig englishMale = GameImageConfig(
    mode: GameMode.male,
    imagePath: englishMaleImagePath,
    fallbackDisplayLabel: 'Male Mode',
    targetArea: TargetArea(x: 0.27, y: 0.25, width: 0.42, height: 0.10),
    placeholderGradientColors: [
      AppColors.surface,
      AppColors.portraitMaleGradientEnd,
    ],
  );

  static const GameImageConfig englishFemale = GameImageConfig(
    mode: GameMode.female,
    imagePath: englishFemaleImagePath,
    fallbackDisplayLabel: 'Female Mode',
    targetArea: TargetArea(x: 0.25, y: 0.29, width: 0.43, height: 0.10),
    placeholderGradientColors: [
      AppColors.surface,
      AppColors.portraitFemaleGradientEnd,
    ],
  );

  static const List<GameImageConfig> all = [
    koreanMale,
    koreanFemale,
    englishMale,
    englishFemale,
  ];

  static GameImageConfig forMode(GameMode mode, {Locale? locale}) {
    final isKorean = locale?.languageCode.toLowerCase() == 'ko';

    switch (mode) {
      case GameMode.male:
        return isKorean ? koreanMale : englishMale;
      case GameMode.female:
        return isKorean ? koreanFemale : englishFemale;
    }
  }
}

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

  static const String malePlaceholderPath =
      'assets/images/male_mode/sample_01.png';
  static const String femalePlaceholderPath =
      'assets/images/female_mode/sample_01.png';

  static const GameImageConfig male = GameImageConfig(
    mode: GameMode.male,
    imagePath: malePlaceholderPath,
    fallbackDisplayLabel: 'Male Mode',
    targetArea: TargetArea(x: 0.26, y: 0.30, width: 0.48, height: 0.13),
    placeholderGradientColors: [
      AppColors.surface,
      AppColors.portraitMaleGradientEnd,
    ],
  );

  static const GameImageConfig female = GameImageConfig(
    mode: GameMode.female,
    imagePath: femalePlaceholderPath,
    fallbackDisplayLabel: 'Female Mode',
    targetArea: TargetArea(x: 0.25, y: 0.29, width: 0.50, height: 0.14),
    placeholderGradientColors: [
      AppColors.surface,
      AppColors.portraitFemaleGradientEnd,
    ],
  );

  static const List<GameImageConfig> all = [male, female];

  static GameImageConfig forMode(GameMode mode) {
    switch (mode) {
      case GameMode.male:
        return male;
      case GameMode.female:
        return female;
    }
  }
}

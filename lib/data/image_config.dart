import '../models/game_mode.dart';
import '../models/target_area.dart';

class ImageConfig {
  const ImageConfig({
    required this.mode,
    required this.imagePath,
    required this.targetArea,
  });

  final GameMode mode;
  final String imagePath;
  final TargetArea targetArea;

  static ImageConfig forMode(GameMode mode) {
    switch (mode) {
      case GameMode.male:
        return const ImageConfig(
          mode: GameMode.male,
          imagePath: 'assets/images/male_mode/sample_01.png',
          targetArea: TargetArea(x: 0.26, y: 0.30, width: 0.48, height: 0.13),
        );
      case GameMode.female:
        return const ImageConfig(
          mode: GameMode.female,
          imagePath: 'assets/images/female_mode/sample_01.png',
          targetArea: TargetArea(x: 0.25, y: 0.29, width: 0.50, height: 0.14),
        );
    }
  }
}

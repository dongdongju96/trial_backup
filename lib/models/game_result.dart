import 'game_mode.dart';

class GameResult {
  const GameResult({
    required this.mode,
    required this.duration,
    required this.playedAt,
  });

  final GameMode mode;
  final Duration duration;
  final DateTime playedAt;

  String get formattedSeconds {
    return (duration.inMilliseconds / 1000).toStringAsFixed(2);
  }
}

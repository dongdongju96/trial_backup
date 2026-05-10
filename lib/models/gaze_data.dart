class GazeData {
  const GazeData({
    required this.isFaceDetected,
    required this.isEyesDetected,
    required this.gazeX,
    required this.gazeY,
  });

  final bool isFaceDetected;
  final bool isEyesDetected;

  /// -1.0 means looking left, 0.0 means centered, 1.0 means looking right.
  final double gazeX;

  /// -1.0 means looking up, 0.0 means centered, 1.0 means looking down.
  final double gazeY;
}

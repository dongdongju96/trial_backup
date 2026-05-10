import 'dart:ui';

class FaceLandmarkResult {
  const FaceLandmarkResult({
    required this.isFaceDetected,
    required this.leftEyePoints,
    required this.rightEyePoints,
    this.leftIrisCenter,
    this.rightIrisCenter,
  });

  final bool isFaceDetected;

  /// Normalized points around the user's left eye.
  final List<Offset> leftEyePoints;

  /// Normalized points around the user's right eye.
  final List<Offset> rightEyePoints;

  /// Optional normalized iris center. MediaPipe may provide this in some modes.
  final Offset? leftIrisCenter;
  final Offset? rightIrisCenter;

  bool get hasEyeData {
    return leftEyePoints.isNotEmpty && rightEyePoints.isNotEmpty;
  }
}

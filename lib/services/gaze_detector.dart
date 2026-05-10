import 'dart:collection';
import 'dart:ui';

import '../models/face_landmark_result.dart';
import '../models/gaze_data.dart';
import '../models/target_area.dart';

class GazeDetector {
  GazeDetector({
    this.frameWindow = 10,
    this.failThreshold = 7,
    this.maxGazeX = 0.65,
    this.maxDownGazeY = 0.65,
  });

  final int frameWindow;
  final int failThreshold;

  /// The user fails when gazeX is too far left or right.
  final double maxGazeX;

  /// The user fails when gazeY is too far down.
  final double maxDownGazeY;

  final Queue<bool> _recentFailures = Queue<bool>();

  bool updateFromLandmarks(FaceLandmarkResult result, TargetArea targetArea) {
    // targetArea is kept in the API because later calibration can compare the
    // user's gaze against the image eye target. For now, gaze is estimated from
    // the user's eye landmarks only.
    final gazeData = _toGazeData(result);
    return update(gazeData);
  }

  bool update(GazeData gazeData) {
    final failed =
        !gazeData.isFaceDetected ||
        !gazeData.isEyesDetected ||
        gazeData.gazeX.abs() > maxGazeX ||
        gazeData.gazeY > maxDownGazeY;

    _recentFailures.addLast(failed);
    while (_recentFailures.length > frameWindow) {
      _recentFailures.removeFirst();
    }

    final failCount = _recentFailures.where((value) => value).length;
    return failCount < failThreshold;
  }

  void reset() {
    _recentFailures.clear();
  }

  GazeData _toGazeData(FaceLandmarkResult result) {
    if (!result.isFaceDetected || !result.hasEyeData) {
      return const GazeData(
        isFaceDetected: false,
        isEyesDetected: false,
        gazeX: 1,
        gazeY: 1,
      );
    }

    final leftGaze = _calculateEyeGaze(
      eyePoints: result.leftEyePoints,
      irisCenter: result.leftIrisCenter,
    );
    final rightGaze = _calculateEyeGaze(
      eyePoints: result.rightEyePoints,
      irisCenter: result.rightIrisCenter,
    );

    final averageGazeX = (leftGaze.dx + rightGaze.dx) / 2;
    final averageGazeY = (leftGaze.dy + rightGaze.dy) / 2;

    return GazeData(
      isFaceDetected: true,
      isEyesDetected: true,
      gazeX: averageGazeX.clamp(-1.0, 1.0),
      gazeY: averageGazeY.clamp(-1.0, 1.0),
    );
  }

  Offset _calculateEyeGaze({
    required List<Offset> eyePoints,
    required Offset? irisCenter,
  }) {
    final eyeCenter = _average(eyePoints);
    if (irisCenter == null) {
      return Offset.zero;
    }

    final bounds = _boundsFor(eyePoints);
    final halfWidth = (bounds.width / 2).clamp(0.001, double.infinity);
    final halfHeight = (bounds.height / 2).clamp(0.001, double.infinity);

    return Offset(
      (irisCenter.dx - eyeCenter.dx) / halfWidth,
      (irisCenter.dy - eyeCenter.dy) / halfHeight,
    );
  }

  Rect _boundsFor(List<Offset> points) {
    var minX = points.first.dx;
    var maxX = points.first.dx;
    var minY = points.first.dy;
    var maxY = points.first.dy;

    for (final point in points.skip(1)) {
      minX = point.dx < minX ? point.dx : minX;
      maxX = point.dx > maxX ? point.dx : maxX;
      minY = point.dy < minY ? point.dy : minY;
      maxY = point.dy > maxY ? point.dy : maxY;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Offset _average(List<Offset> points) {
    final total = points.fold<Offset>(Offset.zero, (sum, point) => sum + point);
    return Offset(total.dx / points.length, total.dy / points.length);
  }
}

class MockGazeDetector extends GazeDetector {
  MockGazeDetector() : super(frameWindow: 10, failThreshold: 7);
}

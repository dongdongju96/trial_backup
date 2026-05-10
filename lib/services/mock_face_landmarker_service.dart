import 'dart:async';
import 'dart:ui';

import '../models/face_landmark_result.dart';
import 'face_landmarker_service.dart';

class MockFaceLandmarkerService implements FaceLandmarkerService {
  DateTime? _startedAt;

  @override
  Future<void> initialize() async {
    // Mark the start time so the mock can fail after a few seconds.
    _startedAt = DateTime.now();
  }

  @override
  Future<FaceLandmarkResult> processFrame(Object? frame) async {
    // The frame argument is ignored in the mock. Real MediaPipe processing will
    // use this camera frame to detect face landmarks on-device.
    await Future<void>.delayed(const Duration(milliseconds: 8));
    final elapsed = DateTime.now().difference(_startedAt ?? DateTime.now());
    final shouldLookAway = elapsed > const Duration(seconds: 8);
    final irisShift = shouldLookAway ? 0.35 : 0.02;

    return FaceLandmarkResult(
      isFaceDetected: true,
      leftEyePoints: const [Offset(0.35, 0.42), Offset(0.43, 0.42)],
      rightEyePoints: const [Offset(0.57, 0.42), Offset(0.65, 0.42)],
      leftIrisCenter: Offset(0.39 + irisShift, 0.42),
      rightIrisCenter: Offset(0.61 + irisShift, 0.42),
    );
  }

  @override
  Future<void> dispose() async {}
}

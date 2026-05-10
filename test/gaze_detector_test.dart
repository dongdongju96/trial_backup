import 'package:eye_lock_challenge/models/face_landmark_result.dart';
import 'package:eye_lock_challenge/models/gaze_data.dart';
import 'package:eye_lock_challenge/models/target_area.dart';
import 'package:eye_lock_challenge/services/gaze_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const targetArea = TargetArea(x: 0.25, y: 0.30, width: 0.50, height: 0.14);

  test('keeps playing when gaze stays centered', () {
    final detector = GazeDetector();

    for (var i = 0; i < 10; i++) {
      final isStillLooking = detector.updateFromLandmarks(
        _landmarksWithIris(leftIrisX: 0.40, rightIrisX: 0.60),
        targetArea,
      );

      expect(isStillLooking, isTrue);
    }
  });

  test('fails when 7 out of the latest 10 frames look away', () {
    final detector = GazeDetector();

    for (var i = 0; i < 6; i++) {
      expect(
        detector.update(
          const GazeData(
            isFaceDetected: true,
            isEyesDetected: true,
            gazeX: 1,
            gazeY: 0,
          ),
        ),
        isTrue,
      );
    }

    expect(
      detector.update(
        const GazeData(
          isFaceDetected: true,
          isEyesDetected: true,
          gazeX: 1,
          gazeY: 0,
        ),
      ),
      isFalse,
    );
  });

  test('treats missing face as gaze failure', () {
    final detector = GazeDetector();

    for (var i = 0; i < 6; i++) {
      expect(
        detector.updateFromLandmarks(
          const FaceLandmarkResult(
            isFaceDetected: false,
            leftEyePoints: [],
            rightEyePoints: [],
          ),
          targetArea,
        ),
        isTrue,
      );
    }

    expect(
      detector.updateFromLandmarks(
        const FaceLandmarkResult(
          isFaceDetected: false,
          leftEyePoints: [],
          rightEyePoints: [],
        ),
        targetArea,
      ),
      isFalse,
    );
  });
}

FaceLandmarkResult _landmarksWithIris({
  required double leftIrisX,
  required double rightIrisX,
}) {
  return FaceLandmarkResult(
    isFaceDetected: true,
    leftEyePoints: const [
      Offset(0.36, 0.40),
      Offset(0.44, 0.40),
      Offset(0.44, 0.44),
      Offset(0.36, 0.44),
    ],
    rightEyePoints: const [
      Offset(0.56, 0.40),
      Offset(0.64, 0.40),
      Offset(0.64, 0.44),
      Offset(0.56, 0.44),
    ],
    leftIrisCenter: Offset(leftIrisX, 0.42),
    rightIrisCenter: Offset(rightIrisX, 0.42),
  );
}

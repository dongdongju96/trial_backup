import '../models/face_landmark_result.dart';

/// Common interface for face landmark detection.
///
/// The rest of the app depends on this abstract class instead of depending on
/// MediaPipe directly. That means the UI and game logic can keep working with a
/// mock service now, then switch to the real MediaPipe service later.
abstract class FaceLandmarkerService {
  /// Prepare any detector resources before frames are processed.
  Future<void> initialize();

  /// Process one camera frame and return normalized face landmark data.
  Future<FaceLandmarkResult> processFrame(Object? frame);

  /// Release detector resources when the game is finished.
  Future<void> dispose();
}

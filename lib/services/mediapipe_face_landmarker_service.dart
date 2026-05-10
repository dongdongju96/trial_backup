import 'package:flutter/services.dart';

import '../models/face_landmark_result.dart';
import 'face_landmarker_service.dart';

class MediaPipeFaceLandmarkerService implements FaceLandmarkerService {
  static const String modelAssetPath = 'assets/models/face_landmarker.task';

  ByteData? _modelBytes;

  @override
  Future<void> initialize() async {
    // This loads the MediaPipe task model from Flutter assets.
    // Add the real face_landmarker.task file at:
    // assets/models/face_landmarker.task
    _modelBytes = await rootBundle.load(modelAssetPath);

    // TODO(MediaPipe): Create the real Face Landmarker instance here.
    //
    // Depending on the MediaPipe Flutter support available in your project,
    // this may happen in one of two ways:
    // 1. Use a Flutter-compatible MediaPipe package directly in Dart.
    // 2. Add Android/iOS native bridge code with MethodChannel or
    //    EventChannel. The native side should receive the model bytes/path,
    //    process camera frames on-device, and return normalized landmark
    //    points back to Dart.
    //
    // Important: camera frames must stay local. Do not save frames and do not
    // upload frames to any server.
  }

  @override
  Future<FaceLandmarkResult> processFrame(Object? frame) async {
    if (_modelBytes == null) {
      throw StateError('MediaPipeFaceLandmarkerService is not initialized.');
    }

    // TODO(MediaPipe): Convert the camera frame into the image format expected
    // by MediaPipe Face Landmarker, then run inference.
    //
    // The returned result should use normalized coordinates from 0.0 to 1.0,
    // matching FaceLandmarkResult and GazeDetector.
    throw UnimplementedError(
      'Real MediaPipe frame processing will be added after native bridge setup.',
    );
  }

  @override
  Future<void> dispose() async {
    // TODO(MediaPipe): Close the real MediaPipe detector or native bridge here.
    _modelBytes = null;
  }
}

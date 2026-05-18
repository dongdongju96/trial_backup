import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

import '../models/face_landmark_result.dart';
import 'camera_frame.dart';
import 'face_landmarker_service.dart';

class MediaPipeFaceLandmarkerService implements FaceLandmarkerService {
  MediaPipeFaceLandmarkerService({
    this.minInferenceInterval = const Duration(milliseconds: 100),
  });

  static const String modelAssetPath = 'assets/models/face_landmarker.task';
  static const MethodChannel _channel = MethodChannel(
    'eye_lock_challenge/face_landmarker',
  );

  final Duration minInferenceInterval;

  DateTime? _lastInferenceAt;

  @override
  Future<void> initialize() async {
    final modelBytes = await rootBundle.load(modelAssetPath);
    await _channel.invokeMethod<void>('initialize', {
      'modelBytes': modelBytes.buffer.asUint8List(),
      'minFaceDetectionConfidence': 0.55,
      'minFacePresenceConfidence': 0.55,
      'minTrackingConfidence': 0.55,
    });
  }

  @override
  Future<FaceLandmarkResult> processFrame(Object? frame) async {
    if (frame is! CameraFrame) {
      return const FaceLandmarkResult(
        isFaceDetected: false,
        leftEyePoints: [],
        rightEyePoints: [],
      );
    }

    final now = DateTime.now();
    final lastInferenceAt = _lastInferenceAt;
    if (lastInferenceAt != null &&
        now.difference(lastInferenceAt) < minInferenceInterval) {
      return const FaceLandmarkResult(
        isFaceDetected: false,
        leftEyePoints: [],
        rightEyePoints: [],
        isSkippedFrame: true,
      );
    }
    _lastInferenceAt = now;

    final result = await _channel.invokeMapMethod<String, Object?>(
      'detect',
      _frameToMessage(frame),
    );
    return _resultFromMessage(result);
  }

  @override
  Future<void> dispose() async {
    _lastInferenceAt = null;
    await _channel.invokeMethod<void>('dispose');
  }

  Map<String, Object?> _frameToMessage(CameraFrame frame) {
    final image = frame.image;
    return {
      'width': image.width,
      'height': image.height,
      'format': image.format.group.name,
      'sensorOrientation': frame.sensorOrientation,
      'isFrontFacing': frame.isFrontFacing,
      'timestampMs': frame.timestamp.millisecondsSinceEpoch,
      'platform': Platform.operatingSystem,
      'planes': image.planes.map(_planeToMessage).toList(growable: false),
    };
  }

  Map<String, Object?> _planeToMessage(Plane plane) {
    return {
      'bytes': Uint8List.fromList(plane.bytes),
      'bytesPerRow': plane.bytesPerRow,
      'bytesPerPixel': plane.bytesPerPixel ?? 1,
      'width': plane.width,
      'height': plane.height,
    };
  }

  FaceLandmarkResult _resultFromMessage(Map<String, Object?>? message) {
    if (message == null || message['isFaceDetected'] != true) {
      return const FaceLandmarkResult(
        isFaceDetected: false,
        leftEyePoints: [],
        rightEyePoints: [],
      );
    }

    return FaceLandmarkResult(
      isFaceDetected: true,
      leftEyePoints: _pointsFromMessage(message['leftEyePoints']),
      rightEyePoints: _pointsFromMessage(message['rightEyePoints']),
      leftIrisCenter: _pointFromMessage(message['leftIrisCenter']),
      rightIrisCenter: _pointFromMessage(message['rightIrisCenter']),
    );
  }

  List<Offset> _pointsFromMessage(Object? value) {
    if (value is! List<Object?>) {
      return const [];
    }

    return value
        .map(_pointFromMessage)
        .whereType<Offset>()
        .toList(growable: false);
  }

  Offset? _pointFromMessage(Object? value) {
    if (value is! Map<Object?, Object?>) {
      return null;
    }

    final x = value['x'];
    final y = value['y'];
    if (x is! num || y is! num) {
      return null;
    }

    return Offset(x.toDouble(), y.toDouble());
  }
}

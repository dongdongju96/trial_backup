import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

import 'camera_frame.dart';

typedef CameraFrameCallback = void Function(CameraFrame frame);

class CameraService {
  CameraController? _controller;
  CameraDescription? _camera;
  bool _isStreaming = false;

  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;
  bool get isStreaming => _isStreaming;

  Future<void> initializeFrontCamera() async {
    if (isInitialized) {
      return;
    }

    final cameras = await availableCameras();
    final frontCamera = cameras
        .where((camera) => camera.lensDirection == CameraLensDirection.front)
        .firstOrNull;

    if (frontCamera == null) {
      throw CameraException(
        'front_camera_not_found',
        'No front-facing camera is available on this device.',
      );
    }

    _camera = frontCamera;
    final controller = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: defaultTargetPlatform == TargetPlatform.iOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.yuv420,
    );

    await controller.initialize();
    _controller = controller;
  }

  Future<void> startImageStream(CameraFrameCallback onFrame) async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isStreaming) {
      return;
    }

    await controller.startImageStream((image) {
      // Frames stay in memory only long enough for real-time processing.
      // They are never saved locally or uploaded anywhere.
      onFrame(
        CameraFrame(
          image: image,
          sensorOrientation: _camera?.sensorOrientation ?? 0,
          isFrontFacing: _camera?.lensDirection == CameraLensDirection.front,
          timestamp: DateTime.now(),
        ),
      );
    });
    _isStreaming = true;
  }

  Future<void> stopImageStream() async {
    final controller = _controller;
    if (controller == null || !_isStreaming) {
      return;
    }

    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    _isStreaming = false;
  }

  Future<void> dispose() async {
    await stopImageStream();
    await _controller?.dispose();
    _controller = null;
    _camera = null;
  }
}

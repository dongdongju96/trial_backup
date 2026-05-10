import 'package:camera/camera.dart';

typedef CameraFrameCallback = void Function(CameraImage frame);

class CameraService {
  CameraController? _controller;
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

    final controller = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
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
      onFrame(image);
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
  }
}

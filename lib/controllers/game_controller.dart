import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/image_config.dart';
import '../models/game_mode.dart';
import '../models/game_feedback_type.dart';
import '../models/game_result.dart';
import '../models/game_state.dart';
import '../services/camera_service.dart';
import '../services/face_landmarker_service.dart';
import '../services/game_timer_service.dart';
import '../services/gaze_detector.dart';

class GameController extends ChangeNotifier {
  GameController({
    required this.mode,
    required this.imageConfig,
    required this.timerService,
    required this.cameraService,
    required this.faceLandmarkerService,
    required this.gazeDetector,
  }) {
    timerService.elapsed.addListener(notifyListeners);
  }

  final GameMode mode;
  final ImageConfig imageConfig;
  final GameTimerService timerService;
  final CameraService cameraService;
  final FaceLandmarkerService faceLandmarkerService;
  final GazeDetector gazeDetector;

  GameState _state = GameState.idle;
  Timer? _mockFallbackTimer;
  GameResult? _result;
  bool _isProcessingFrame = false;
  GameFeedbackType? _cameraFeedback;
  GameFeedbackType? _trackingFeedback;

  GameState get state => _state;
  GameResult? get result => _result;
  Duration get elapsed => timerService.elapsed.value;
  GameFeedbackType? get cameraFeedback => _cameraFeedback;
  GameFeedbackType? get trackingFeedback => _trackingFeedback;

  // The image should be fully visible only after the countdown has finished.
  bool get isImageRevealed =>
      _state == GameState.playing ||
      _state == GameState.failed ||
      _state == GameState.finished;

  Future<void> prepare() async {
    // Prepare mock face tracking and the front camera before countdown starts.
    _setState(GameState.preparing);
    await faceLandmarkerService.initialize();

    try {
      await cameraService.initializeFrontCamera();
      _cameraFeedback = null;
    } catch (error) {
      // The game can still run with mock frames on simulators or devices
      // without an available front camera.
      _cameraFeedback = GameFeedbackType.cameraUnavailable;
    }

    _setState(GameState.countdown);
  }

  Future<void> startPlaying() async {
    if (_state != GameState.countdown) {
      return;
    }

    gazeDetector.reset();
    timerService.reset();
    timerService.start();
    _setState(GameState.playing);

    await _startCameraTracking();
  }

  Future<void> failGame() async {
    if (_state != GameState.playing) {
      return;
    }

    _setState(GameState.failed);
    _mockFallbackTimer?.cancel();
    await cameraService.stopImageStream();
    timerService.stop();
    _result = GameResult(
      mode: mode,
      duration: timerService.elapsed.value,
      playedAt: DateTime.now(),
    );
    _setState(GameState.finished);
  }

  Future<void> _startCameraTracking() async {
    if (!cameraService.isInitialized) {
      _startMockFallbackTracking();
      return;
    }

    try {
      await cameraService.startImageStream(_processCameraFrame);
    } catch (error) {
      _cameraFeedback = GameFeedbackType.cameraStreamUnavailable;
      notifyListeners();
      _startMockFallbackTracking();
    }
  }

  void _startMockFallbackTracking() {
    _mockFallbackTimer?.cancel();
    _mockFallbackTimer = Timer.periodic(
      const Duration(milliseconds: 120),
      (_) => _processCameraFrame(null),
    );
  }

  Future<void> _processCameraFrame(Object? frame) async {
    if (_isProcessingFrame || _state != GameState.playing) {
      return;
    }

    _isProcessingFrame = true;
    try {
      // The controller talks only to the abstract service. This keeps the UI
      // independent from the future MediaPipe implementation.
      final landmarks = await faceLandmarkerService.processFrame(frame);
      _updateTrackingMessage(
        isFaceDetected: landmarks.isFaceDetected,
        isEyesDetected: landmarks.hasEyeData,
      );

      final isStillLooking = gazeDetector.updateFromLandmarks(
        landmarks,
        imageConfig.targetArea,
      );
      if (!isStillLooking) {
        await failGame();
      }
    } finally {
      _isProcessingFrame = false;
    }
  }

  void _setState(GameState value) {
    _state = value;
    notifyListeners();
  }

  void _updateTrackingMessage({
    required bool isFaceDetected,
    required bool isEyesDetected,
  }) {
    if (!isFaceDetected) {
      _trackingFeedback = GameFeedbackType.noFaceDetected;
    } else if (!isEyesDetected) {
      _trackingFeedback = GameFeedbackType.noEyesDetected;
    } else {
      _trackingFeedback = null;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _mockFallbackTimer?.cancel();
    timerService.elapsed.removeListener(notifyListeners);
    timerService.dispose();
    unawaited(cameraService.dispose());
    unawaited(faceLandmarkerService.dispose());
    super.dispose();
  }
}

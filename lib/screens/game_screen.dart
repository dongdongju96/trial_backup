import 'package:flutter/material.dart';

import '../controllers/game_controller.dart';
import '../data/image_config.dart';
import '../models/game_feedback_type.dart';
import '../models/game_mode.dart';
import '../models/game_state.dart';
import '../services/camera_service.dart';
import '../services/game_timer_service.dart';
import '../services/gaze_detector.dart';
import '../services/mock_face_landmarker_service.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/game_timer_widget.dart';
import '../widgets/masked_image_widget.dart';
import 'result_screen.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.mode, super.key});

  static const String routeName = '/game';

  final GameMode mode;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _controller;

  @override
  void initState() {
    super.initState();
    final imageConfig = ImageConfig.forMode(widget.mode);
    _controller = GameController(
      mode: widget.mode,
      imageConfig: imageConfig,
      timerService: GameTimerService(),
      cameraService: CameraService(),
      faceLandmarkerService: MockFaceLandmarkerService(),
      gazeDetector: MockGazeDetector(),
    )..addListener(_handleGameUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.prepare();
    });
  }

  void _handleGameUpdate() {
    final result = _controller.result;
    if (_controller.state == GameState.finished && result != null && mounted) {
      _controller.removeListener(_handleGameUpdate);
      Navigator.of(
        context,
      ).pushReplacementNamed(ResultScreen.routeName, arguments: result);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleGameUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final localizations = AppLocalizations.of(context);

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _modeLabel(localizations, widget.mode),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      GameTimerWidget(elapsed: _controller.elapsed),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          MaskedImageWidget(
                            imagePath: _controller.imageConfig.imagePath,
                            targetArea: _controller.imageConfig.targetArea,
                            isRevealed: _controller.isImageRevealed,
                            mode: widget.mode,
                          ),
                          if (_controller.state == GameState.countdown)
                            CountdownWidget(
                              onFinished: _controller.startPlaying,
                            ),
                          if (_controller.state == GameState.preparing)
                            const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CameraPreviewWidget(
                        controller: _controller.cameraService.controller,
                        statusText: _feedbackText(
                          localizations,
                          _controller.cameraFeedback,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _statusText(localizations, _controller.state),
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _modeLabel(AppLocalizations localizations, GameMode mode) {
    switch (mode) {
      case GameMode.male:
        return localizations.maleMode;
      case GameMode.female:
        return localizations.femaleMode;
    }
  }

  String _statusText(AppLocalizations localizations, GameState state) {
    final trackingFeedback = _feedbackText(
      localizations,
      _controller.trackingFeedback,
    );
    if (trackingFeedback != null) {
      return trackingFeedback;
    }

    final cameraFeedback = _feedbackText(
      localizations,
      _controller.cameraFeedback,
    );
    if (cameraFeedback != null) {
      return cameraFeedback;
    }

    switch (state) {
      case GameState.idle:
      case GameState.preparing:
        return localizations.preparingChallenge;
      case GameState.countdown:
        return localizations.countdownInstruction;
      case GameState.playing:
        return localizations.mockTrackingActive;
      case GameState.failed:
        return localizations.gazeMovedAway;
      case GameState.finished:
        return localizations.savingResult;
    }
  }

  String? _feedbackText(
    AppLocalizations localizations,
    GameFeedbackType? feedback,
  ) {
    switch (feedback) {
      case GameFeedbackType.cameraUnavailable:
        return localizations.cameraUnavailableMessage;
      case GameFeedbackType.cameraStreamUnavailable:
        return localizations.cameraStreamUnavailableMessage;
      case GameFeedbackType.noFaceDetected:
        return localizations.noFaceDetectedMessage;
      case GameFeedbackType.noEyesDetected:
        return localizations.noEyesDetectedMessage;
      case null:
        return null;
    }
  }
}

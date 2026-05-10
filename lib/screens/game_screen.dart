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
import '../utils/constants.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/countdown_widget.dart';
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
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.gamePadding),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.15,
                  colors: [
                    AppColors.primaryBlue.withValues(alpha: 0.16),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  _GameHud(
                    modeLabel: _modeLabel(localizations, widget.mode),
                    elapsedText: _formatHudTime(_controller.elapsed),
                    statusText: _hudStatusText(localizations),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: Center(
                      child: MaskedImageWidget(
                        imagePath: _controller.imageConfig.imagePath,
                        targetArea: _controller.imageConfig.targetArea,
                        isRevealed: _controller.isImageRevealed,
                        overlay: _buildImageOverlay(localizations),
                      ),
                    ),
                  ),
                  if (AppConstants.showDebugCameraPreview) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        CameraPreviewWidget(
                          controller: _controller.cameraService.controller,
                          statusText: _feedbackText(
                            localizations,
                            _controller.cameraFeedback,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _statusText(localizations, _controller.state),
                            style: AppTextStyles.smallBody,
                          ),
                        ),
                      ],
                    ),
                  ],
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

  Widget? _buildImageOverlay(AppLocalizations localizations) {
    if (_controller.state == GameState.countdown) {
      return CountdownWidget(
        lockText: localizations.countdownLock,
        onFinished: _controller.startPlaying,
      );
    }

    if (_controller.state == GameState.preparing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.state == GameState.playing) {
      return _GameplayImageOverlay(
        instruction: localizations.gameplayInstruction,
        stabilityLabel: localizations.focusStability,
      );
    }

    return null;
  }

  String _formatHudTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final centiseconds = (duration.inMilliseconds.remainder(1000) ~/ 10)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds.$centiseconds';
  }

  String _hudStatusText(AppLocalizations localizations) {
    final feedbackText = _feedbackText(
      localizations,
      _controller.trackingFeedback ?? _controller.cameraFeedback,
    );
    return feedbackText ?? localizations.focusLocked;
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

class _GameHud extends StatelessWidget {
  const _GameHud({
    required this.modeLabel,
    required this.elapsedText,
    required this.statusText,
  });

  final String modeLabel;
  final String elapsedText;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.cyanAccent.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.center_focus_strong, color: AppColors.cyanAccent),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                modeLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.smallBody,
              ),
            ),
            Text(
              elapsedText,
              style: AppTextStyles.timer.copyWith(fontSize: 28),
            ),
            const SizedBox(width: AppSpacing.sm),
            Tooltip(
              message: statusText,
              child: const Icon(Icons.favorite, color: AppColors.pinkAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameplayImageOverlay extends StatelessWidget {
  const _GameplayImageOverlay({
    required this.instruction,
    required this.stabilityLabel,
  });

  final String instruction;
  final String stabilityLabel;

  @override
  Widget build(BuildContext context) {
    const stabilityValue = 0.82;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(
            color: AppColors.cyanAccent.withValues(alpha: 0.34),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(instruction, style: AppTextStyles.modeLabel),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(stabilityLabel, style: AppTextStyles.smallBody),
                ),
                Text(
                  '${(stabilityValue * 100).round()}%',
                  style: AppTextStyles.smallBody.copyWith(
                    color: AppColors.cyanAccent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.round),
              child: LinearProgressIndicator(
                minHeight: 8,
                value: stabilityValue,
                backgroundColor: AppColors.surfaceLight,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.cyanAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

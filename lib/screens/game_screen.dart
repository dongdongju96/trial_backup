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
  GameController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) {
      return;
    }

    // The selected app language decides which localized image set is used.
    // GameController still receives one fixed config, so countdown and gameplay
    // always share the exact same image and target eye area.
    final locale = Localizations.localeOf(context);
    final imageConfig = ImageConfig.forMode(widget.mode, locale: locale);
    final controller = GameController(
      mode: widget.mode,
      imageConfig: imageConfig,
      timerService: GameTimerService(),
      cameraService: CameraService(),
      faceLandmarkerService: MockFaceLandmarkerService(),
      gazeDetector: MockGazeDetector(),
    )..addListener(_handleGameUpdate);
    _controller = controller;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.prepare();
    });
  }

  void _handleGameUpdate() {
    final controller = _controller;
    if (controller == null) {
      return;
    }

    final result = controller.result;
    if (controller.state == GameState.finished && result != null && mounted) {
      controller.removeListener(_handleGameUpdate);
      Navigator.of(
        context,
      ).pushReplacementNamed(ResultScreen.routeName, arguments: result);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleGameUpdate);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AnimatedBuilder(
      animation: controller,
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
                    elapsedText: _formatHudTime(controller.elapsed),
                    statusText: _hudStatusText(localizations, controller),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: Center(
                      child: MaskedImageWidget(
                        imagePath: controller.imageConfig.imagePath,
                        targetArea: controller.imageConfig.targetArea,
                        isRevealed: controller.isImageRevealed,
                        overlay: _buildImageOverlay(localizations, controller),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Visibility(
                    visible: controller.state == GameState.playing,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainState: true,
                    child: _GameplayStatusPanel(
                      instruction: localizations.gameplayInstruction,
                      stabilityLabel: localizations.focusStability,
                    ),
                  ),
                  if (AppConstants.showDebugCameraPreview) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        CameraPreviewWidget(
                          controller: controller.cameraService.controller,
                          statusText: _feedbackText(
                            localizations,
                            controller.cameraFeedback,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            _statusText(localizations, controller),
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

  Widget? _buildImageOverlay(
    AppLocalizations localizations,
    GameController controller,
  ) {
    if (controller.state == GameState.countdown) {
      return CountdownWidget(
        lockText: localizations.countdownLock,
        onFinished: controller.startPlaying,
      );
    }

    if (controller.state == GameState.preparing) {
      return const Center(child: CircularProgressIndicator());
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

  String _hudStatusText(
    AppLocalizations localizations,
    GameController controller,
  ) {
    final feedbackText = _feedbackText(
      localizations,
      controller.trackingFeedback ?? controller.cameraFeedback,
    );
    return feedbackText ?? localizations.focusLocked;
  }

  String _statusText(
    AppLocalizations localizations,
    GameController controller,
  ) {
    final trackingFeedback = _feedbackText(
      localizations,
      controller.trackingFeedback,
    );
    if (trackingFeedback != null) {
      return trackingFeedback;
    }

    final cameraFeedback = _feedbackText(
      localizations,
      controller.cameraFeedback,
    );
    if (cameraFeedback != null) {
      return cameraFeedback;
    }

    switch (controller.state) {
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

class _GameplayStatusPanel extends StatelessWidget {
  const _GameplayStatusPanel({
    required this.instruction,
    required this.stabilityLabel,
  });

  final String instruction;
  final String stabilityLabel;

  @override
  Widget build(BuildContext context) {
    const stabilityValue = 0.82;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.cyanAccent.withValues(alpha: 0.34)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
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

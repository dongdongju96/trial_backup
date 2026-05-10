import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../models/game_mode.dart';
import '../services/permission_service.dart';
import '../utils/constants.dart';
import '../widgets/neon_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/privacy_check_item.dart';
import '../widgets/secondary_button.dart';
import 'game_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({required this.mode, super.key});

  static const String routeName = '/permission';

  final GameMode mode;

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final PermissionService _permissionService = PermissionService();
  bool _isChecking = true;
  bool _isRequesting = false;
  CameraPermissionState _permissionState = CameraPermissionState.denied;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final permissionState = await _permissionService.checkCameraPermission();
    if (!mounted) {
      return;
    }
    setState(() {
      _permissionState = permissionState;
      _isChecking = false;
    });
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isRequesting = true;
    });

    final permissionState = await _permissionService.requestCameraPermission();
    if (!mounted) {
      return;
    }

    setState(() {
      _permissionState = permissionState;
      _isRequesting = false;
    });

    if (permissionState == CameraPermissionState.granted) {
      _startGame();
    }
  }

  void _startGame() {
    Navigator.of(
      context,
    ).pushReplacementNamed(GameScreen.routeName, arguments: widget.mode);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topCenter,
                        radius: 1.1,
                        colors: [
                          AppColors.cyanAccent.withValues(alpha: 0.14),
                          AppColors.background,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Spacer(),
                        Center(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: AppShadows.neonGlow(
                                AppColors.cyanAccent,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 42,
                              backgroundColor: AppColors.surfaceLight,
                              child: Icon(
                                Icons.photo_camera_front_outlined,
                                size: 48,
                                color: AppColors.cyanAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          localizations.cameraPermissionTitle,
                          style: AppTextStyles.heroTitle,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          localizations.cameraPermissionDescription,
                          style: AppTextStyles.body,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        NeonCard(
                          glowColor: AppColors.success,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.trustChecklistTitle,
                                style: AppTextStyles.modeLabel,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              PrivacyCheckItem(
                                text: localizations.trustOnDeviceProcessing,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              PrivacyCheckItem(
                                text: localizations.trustNoRecording,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              PrivacyCheckItem(
                                text: localizations.trustNoUpload,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              PrivacyCheckItem(
                                text: localizations.trustNoFaceIdentification,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        if (_isChecking)
                          const Center(child: CircularProgressIndicator())
                        else if (_permissionState ==
                            CameraPermissionState.granted)
                          PrimaryButton(
                            label: localizations.startChallenge,
                            icon: Icons.play_arrow,
                            onPressed: _startGame,
                          )
                        else ...[
                          Text(
                            _permissionState ==
                                    CameraPermissionState.permanentlyDenied
                                ? localizations.cameraPermanentlyDeniedMessage
                                : localizations.cameraDeniedMessage,
                            style: AppTextStyles.smallBody.copyWith(
                              color: AppColors.pinkAccent,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          PrimaryButton(
                            label:
                                _permissionState ==
                                    CameraPermissionState.permanentlyDenied
                                ? localizations.openSettings
                                : _isRequesting
                                ? localizations.requesting
                                : localizations.allowCamera,
                            icon:
                                _permissionState ==
                                    CameraPermissionState.permanentlyDenied
                                ? Icons.settings_outlined
                                : Icons.camera_alt_outlined,
                            onPressed: _isRequesting
                                ? null
                                : _permissionState ==
                                      CameraPermissionState.permanentlyDenied
                                ? () => _permissionService.openSystemSettings()
                                : _requestPermission,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SecondaryButton(
                            label: localizations.later,
                            icon: Icons.arrow_back,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:eye_lock_challenge/l10n/app_localizations.dart';

import '../models/game_mode.dart';
import '../services/permission_service.dart';
import '../utils/constants.dart';
import '../widgets/primary_button.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const Spacer(),
              const Icon(
                Icons.privacy_tip_outlined,
                size: 54,
                color: AppConstants.accentColor,
              ),
              const SizedBox(height: 24),
              Text(
                localizations.cameraPermissionTitle,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localizations.cameraPermissionDescription,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              if (_isChecking)
                const Center(child: CircularProgressIndicator())
              else if (_permissionState == CameraPermissionState.granted)
                PrimaryButton(
                  label: localizations.startChallenge,
                  icon: Icons.play_arrow,
                  onPressed: _startGame,
                )
              else ...[
                Text(
                  _permissionState == CameraPermissionState.permanentlyDenied
                      ? localizations.cameraPermanentlyDeniedMessage
                      : localizations.cameraDeniedMessage,
                  style: const TextStyle(
                    color: AppConstants.warningColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
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
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

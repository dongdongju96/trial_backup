import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({
    required this.controller,
    required this.statusText,
    super.key,
  });

  final CameraController? controller;
  final String? statusText;

  @override
  Widget build(BuildContext context) {
    final cameraController = controller;
    final isReady =
        cameraController != null && cameraController.value.isInitialized;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Container(
        width: 96,
        height: 128,
        decoration: BoxDecoration(
          gradient: AppGradients.surface,
          border: Border.all(
            color: AppColors.cyanAccent.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(AppRadii.sm),
          boxShadow: AppShadows.neonGlow(AppColors.cyanAccent),
        ),
        child: isReady
            ? CameraPreview(cameraController)
            : _PreviewPlaceholder(statusText: statusText),
      ),
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  const _PreviewPlaceholder({required this.statusText});

  final String? statusText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.videocam_off_outlined,
            color: AppColors.textSecondary,
          ),
          if (statusText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              statusText!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.smallBody.copyWith(fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }
}

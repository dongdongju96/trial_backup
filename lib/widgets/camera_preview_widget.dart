import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 96,
        height: 128,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.videocam_off_outlined, color: Colors.white54),
          if (statusText != null) ...[
            const SizedBox(height: 8),
            Text(
              statusText!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ],
      ),
    );
  }
}

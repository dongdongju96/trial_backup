import 'package:flutter/material.dart';

import '../models/target_area.dart';
import '../utils/constants.dart';

class MaskedImageWidget extends StatelessWidget {
  const MaskedImageWidget({
    required this.imagePath,
    required this.targetArea,
    required this.isRevealed,
    this.borderRadius = AppRadii.xl,
    this.overlay,
    super.key,
  });

  final String imagePath;
  final TargetArea targetArea;
  final bool isRevealed;
  final double borderRadius;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);

            // targetArea is normalized, so it must be converted into the
            // current widget's pixel size before the black mask is positioned.
            final targetRect = targetArea.toRect(size);

            return Stack(
              fit: StackFit.expand,
              children: [
                _ChallengeImage(imagePath: imagePath),

                // Countdown state: cover everything except the eye target area.
                if (!isRevealed) ..._buildMaskPieces(size, targetRect),

                // The target outline helps verify that the masked area and
                // gameplay target use the exact same rectangle.
                if (!isRevealed) _TargetOutline(targetRect: targetRect),

                // Extra UI, such as a countdown number, is always rendered last
                // so it appears above both the image and the mask.
                if (overlay != null) Positioned.fill(child: overlay!),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildMaskPieces(Size size, Rect targetRect) {
    return [
      Positioned(
        left: 0,
        top: 0,
        width: size.width,
        height: targetRect.top,
        child: const ColoredBox(color: AppColors.mask),
      ),
      Positioned(
        left: 0,
        top: targetRect.bottom,
        width: size.width,
        height: size.height - targetRect.bottom,
        child: const ColoredBox(color: AppColors.mask),
      ),
      Positioned(
        left: 0,
        top: targetRect.top,
        width: targetRect.left,
        height: targetRect.height,
        child: const ColoredBox(color: AppColors.mask),
      ),
      Positioned(
        left: targetRect.right,
        top: targetRect.top,
        width: size.width - targetRect.right,
        height: targetRect.height,
        child: const ColoredBox(color: AppColors.mask),
      ),
    ];
  }
}

class _ChallengeImage extends StatelessWidget {
  const _ChallengeImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const _PlaceholderPortrait();
      },
    );
  }
}

class _TargetOutline extends StatelessWidget {
  const _TargetOutline({required this.targetRect});

  final Rect targetRect;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: targetRect,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cyanAccent, width: 2),
            borderRadius: BorderRadius.circular(AppRadii.sm),
            boxShadow: AppShadows.neonGlow(AppColors.cyanAccent),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPortrait extends StatelessWidget {
  const _PlaceholderPortrait();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(gradient: AppGradients.portraitMale),
      child: CustomPaint(painter: _PortraitPainter()),
    );
  }
}

class _PortraitPainter extends CustomPainter {
  const _PortraitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final centerX = size.width / 2;

    paint.color = AppColors.placeholderMaleHair;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.35),
        width: size.width * 0.62,
        height: size.height * 0.46,
      ),
      paint,
    );

    paint.color = AppColors.placeholderMaleSkin;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.40),
        width: size.width * 0.48,
        height: size.height * 0.42,
      ),
      paint,
    );

    paint.color = AppColors.textPrimary;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.40, size.height * 0.36),
        width: size.width * 0.095,
        height: size.height * 0.035,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.60, size.height * 0.36),
        width: size.width * 0.095,
        height: size.height * 0.035,
      ),
      paint,
    );

    paint.color = AppColors.mask;
    canvas.drawCircle(Offset(size.width * 0.40, size.height * 0.36), 7, paint);
    canvas.drawCircle(Offset(size.width * 0.60, size.height * 0.36), 7, paint);

    paint
      ..color = AppColors.placeholderMouth
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.50),
        width: size.width * 0.18,
        height: size.height * 0.06,
      ),
      0,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PortraitPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';

import '../models/game_mode.dart';
import '../models/target_area.dart';
import '../utils/constants.dart';

class MaskedImageWidget extends StatelessWidget {
  const MaskedImageWidget({
    required this.imagePath,
    required this.targetArea,
    required this.isRevealed,
    required this.mode,
    super.key,
  });

  final String imagePath;
  final TargetArea targetArea;
  final bool isRevealed;
  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            final targetRect = targetArea.toRect(size);

            return Stack(
              fit: StackFit.expand,
              children: [
                // A real asset can be added later. Until then, the errorBuilder
                // shows a safe placeholder portrait for the selected mode.
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _PlaceholderPortrait(mode: mode);
                  },
                ),
                // Before the countdown finishes, black panels cover everything
                // except the target eye area.
                if (!isRevealed) ..._buildMaskPieces(size, targetRect),
                Positioned.fromRect(
                  rect: targetRect,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppConstants.accentColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
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
        child: const ColoredBox(color: Colors.black),
      ),
      Positioned(
        left: 0,
        top: targetRect.bottom,
        width: size.width,
        height: size.height - targetRect.bottom,
        child: const ColoredBox(color: Colors.black),
      ),
      Positioned(
        left: 0,
        top: targetRect.top,
        width: targetRect.left,
        height: targetRect.height,
        child: const ColoredBox(color: Colors.black),
      ),
      Positioned(
        left: targetRect.right,
        top: targetRect.top,
        width: size.width - targetRect.right,
        height: targetRect.height,
        child: const ColoredBox(color: Colors.black),
      ),
    ];
  }
}

class _PlaceholderPortrait extends StatelessWidget {
  const _PlaceholderPortrait({required this.mode});

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    final isMale = mode == GameMode.male;
    final hairColor = isMale
        ? const Color(0xFF202633)
        : const Color(0xFF4A2637);
    final skinColor = isMale
        ? const Color(0xFFC99371)
        : const Color(0xFFD8A17E);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.surfaceColor,
            isMale ? const Color(0xFF22314A) : const Color(0xFF3B2748),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomPaint(
        painter: _PortraitPainter(hairColor: hairColor, skinColor: skinColor),
      ),
    );
  }
}

class _PortraitPainter extends CustomPainter {
  const _PortraitPainter({required this.hairColor, required this.skinColor});

  final Color hairColor;
  final Color skinColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;
    final centerX = size.width / 2;

    paint.color = hairColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.35),
        width: size.width * 0.62,
        height: size.height * 0.46,
      ),
      paint,
    );

    paint.color = skinColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, size.height * 0.40),
        width: size.width * 0.48,
        height: size.height * 0.42,
      ),
      paint,
    );

    paint.color = Colors.white;
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

    paint.color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.40, size.height * 0.36), 7, paint);
    canvas.drawCircle(Offset(size.width * 0.60, size.height * 0.36), 7, paint);

    paint
      ..color = const Color(0xFF7A4B3A)
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
    paint.style = PaintingStyle.fill;
  }

  @override
  bool shouldRepaint(covariant _PortraitPainter oldDelegate) {
    return oldDelegate.hairColor != hairColor ||
        oldDelegate.skinColor != skinColor;
  }
}

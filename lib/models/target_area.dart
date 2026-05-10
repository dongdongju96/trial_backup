import 'dart:ui';

class TargetArea {
  const TargetArea({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  /// Normalized horizontal position from 0.0 to 1.0.
  final double x;

  /// Normalized vertical position from 0.0 to 1.0.
  final double y;

  /// Normalized width from 0.0 to 1.0.
  final double width;

  /// Normalized height from 0.0 to 1.0.
  final double height;

  bool containsPoint(Offset point) {
    return point.dx >= x &&
        point.dx <= x + width &&
        point.dy >= y &&
        point.dy <= y + height;
  }

  Rect toRect(Size size) {
    return Rect.fromLTWH(
      x * size.width,
      y * size.height,
      width * size.width,
      height * size.height,
    );
  }
}

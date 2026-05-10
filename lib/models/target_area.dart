import 'dart:ui';

class TargetArea {
  const TargetArea({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  }) : assert(x >= 0 && x <= 1),
       assert(y >= 0 && y <= 1),
       assert(width > 0 && width <= 1),
       assert(height > 0 && height <= 1),
       assert(x + width <= 1),
       assert(y + height <= 1);

  /// Normalized horizontal start position from 0.0 to 1.0.
  ///
  /// Example: x = 0.25 means the target starts 25% from the left edge of the
  /// image. Using normalized values keeps the target correct on any screen size.
  final double x;

  /// Normalized vertical start position from 0.0 to 1.0.
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
    // Convert the normalized target area into real pixels for the current
    // widget size. This is what MaskedImageWidget uses to cut out the eye area.
    return Rect.fromLTWH(
      x * size.width,
      y * size.height,
      width * size.width,
      height * size.height,
    );
  }
}

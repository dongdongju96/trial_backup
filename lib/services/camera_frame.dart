import 'package:camera/camera.dart';

class CameraFrame {
  const CameraFrame({
    required this.image,
    required this.sensorOrientation,
    required this.isFrontFacing,
    required this.timestamp,
  });

  final CameraImage image;
  final int sensorOrientation;
  final bool isFrontFacing;
  final DateTime timestamp;
}

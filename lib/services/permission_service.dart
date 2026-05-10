import 'package:permission_handler/permission_handler.dart';

enum CameraPermissionState { granted, denied, permanentlyDenied }

class PermissionService {
  Future<CameraPermissionState> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return _mapStatus(status);
  }

  Future<CameraPermissionState> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return _mapStatus(status);
  }

  Future<bool> openSystemSettings() {
    return openAppSettings();
  }

  CameraPermissionState _mapStatus(PermissionStatus status) {
    if (status.isGranted) {
      return CameraPermissionState.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return CameraPermissionState.permanentlyDenied;
    }
    return CameraPermissionState.denied;
  }
}

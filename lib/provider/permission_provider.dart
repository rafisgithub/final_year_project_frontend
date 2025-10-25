import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier {
  bool _cameraGranted = false;

  bool get cameraGranted => _cameraGranted;

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    _cameraGranted = status.isGranted;
    notifyListeners();
  }
}

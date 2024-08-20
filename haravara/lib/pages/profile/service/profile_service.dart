import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissionCamera() async {
  final permission = Permission.camera;
  final result = await permission.request();
  if (await result.isDenied) {
    final result = await permission.request();
    if (result.isGranted) {
      return true;
    }
  }
  return false;
}

Future<bool> requestPermissionMedia() async {
  final permission = Permission.mediaLibrary;
  final result = await permission.request();
  if (await result.isDenied) {
    final result = await permission.request();
    if (result.isGranted) {
      return true;
    }
  }
  return false;
}

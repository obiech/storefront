import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

@lazySingleton
class DropezyPermissionHandler {
  const DropezyPermissionHandler();

  Future<permission.PermissionStatus> requestPermission(
    permission.Permission permission,
  ) async {
    final status = await permission.request();

    return status;
  }

  static Future<bool> openAppSettings() {
    return permission.openAppSettings();
  }
}

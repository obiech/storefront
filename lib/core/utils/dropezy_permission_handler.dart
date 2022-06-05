import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class DropezyPermissionHandler {
  const DropezyPermissionHandler();

  Future<PermissionStatus> requestPermission(Permission permission) async {
    final status = await permission.request();

    return status;
  }
}

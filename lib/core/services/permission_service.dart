import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  /// Checks the status of a specific [Permission]
  Future<PermissionStatus> status(Permission permission) {
    return permission.status;
  }

  /// Opens the app settings.
  Future<bool> openAppSettings() {
    return openAppSettings();
  }

  /// Requests permissions for a single permission.
  Future<PermissionStatus> request(Permission permission) {
    return permission.request();
  }
}

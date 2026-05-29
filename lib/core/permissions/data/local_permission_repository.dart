import 'package:shared_preferences/shared_preferences.dart';

import '../domain/permission_repository.dart';
import '../domain/permission_status.dart';

class LocalPermissionRepository implements PermissionRepository {
  LocalPermissionRepository(this._preferences);

  static const _locationKey = 'permissions.location_enabled';
  static const _notificationKey = 'permissions.notifications_enabled';

  final SharedPreferences _preferences;

  @override
  Future<PermissionStatus> getStatus() async {
    return PermissionStatus(
      locationSharingEnabled: _preferences.getBool(_locationKey) ?? false,
      notificationsEnabled: _preferences.getBool(_notificationKey) ?? false,
    );
  }

  @override
  Future<PermissionStatus> enableEducationState() async {
    await _preferences.setBool(_locationKey, true);
    await _preferences.setBool(_notificationKey, true);
    return getStatus();
  }
}

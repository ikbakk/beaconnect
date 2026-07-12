import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
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
    final fallback = _readFallbackStatus();
    if (!_supportsRuntimePermissions) {
      return fallback;
    }

    try {
      final locationStatus = await permission_handler.Permission.locationWhenInUse.status;
      final notificationStatus = await permission_handler.Permission.notification.status;
      final status = PermissionStatus(
        locationSharingEnabled: locationStatus.isGranted,
        notificationsEnabled: notificationStatus.isGranted,
      );
      await _saveFallbackStatus(status);
      return status;
    } on MissingPluginException {
      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  @override
  Future<PermissionStatus> enableEducationState() async {
    final fallback = _readFallbackStatus();
    if (!_supportsRuntimePermissions) {
      return fallback;
    }

    try {
      final locationStatus = await permission_handler.Permission.locationWhenInUse.request();
      final notificationStatus = await permission_handler.Permission.notification.request();
      final status = PermissionStatus(
        locationSharingEnabled: locationStatus.isGranted,
        notificationsEnabled: notificationStatus.isGranted,
      );
      await _saveFallbackStatus(status);
      return status;
    } on MissingPluginException {
      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  bool get _supportsRuntimePermissions => Platform.isAndroid || Platform.isIOS;

  PermissionStatus _readFallbackStatus() {
    return PermissionStatus(
      locationSharingEnabled: _preferences.getBool(_locationKey) ?? false,
      notificationsEnabled: _preferences.getBool(_notificationKey) ?? false,
    );
  }

  Future<void> _saveFallbackStatus(PermissionStatus status) async {
    await _preferences.setBool(_locationKey, status.locationSharingEnabled);
    await _preferences.setBool(_notificationKey, status.notificationsEnabled);
  }
}

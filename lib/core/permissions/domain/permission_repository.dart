import 'permission_status.dart';

abstract class PermissionRepository {
  Future<PermissionStatus> getStatus();
  Future<PermissionStatus> enableEducationState();
}

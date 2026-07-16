import '../domain/permission_repository.dart';

class OpenSystemSettingsUseCase {
  const OpenSystemSettingsUseCase(this._repository);

  final PermissionRepository _repository;

  Future<void> call() {
    return _repository.openSystemSettings();
  }
}

import '../domain/permission_repository.dart';
import '../domain/permission_status.dart';

class GetPermissionStatusUseCase {
  const GetPermissionStatusUseCase(this._repository);

  final PermissionRepository _repository;

  Future<PermissionStatus> call() {
    return _repository.getStatus();
  }
}

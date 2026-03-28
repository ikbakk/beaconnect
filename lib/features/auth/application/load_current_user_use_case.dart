import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class LoadCurrentUserUseCase {
  const LoadCurrentUserUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<AppUser?> call() {
    return _authRepository.getCurrentUser();
  }
}

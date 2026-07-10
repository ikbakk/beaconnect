import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class SignUpWithEmailUseCase {
  const SignUpWithEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<AppUser> call({
    required String email,
    required String password,
  }) {
    return _authRepository.signUpWithEmail(email: email, password: password);
  }
}

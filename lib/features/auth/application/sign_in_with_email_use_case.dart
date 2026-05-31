import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class SignInWithEmailUseCase {
  const SignInWithEmailUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<AppUser> call({
    required String email,
    required String password,
  }) {
    return _authRepository.signInWithEmail(email: email, password: password);
  }
}

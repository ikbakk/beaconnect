import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    _currentUser ??= const AppUser(
      id: 'user-1',
      displayName: 'Iqbal',
    );
    return _currentUser!;
  }
}

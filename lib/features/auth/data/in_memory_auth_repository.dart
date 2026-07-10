import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';

class InMemoryAuthRepository implements AuthRepository {
  AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final currentUser = _currentUser;
    final expectedId = _userIdFromEmail(email);
    if (currentUser == null || currentUser.id != expectedId) {
      throw const AuthFailure(
        'We could not find an account with that email yet. Try signing up instead.',
      );
    }

    return currentUser;
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final namePart = normalizedEmail.split('@').first;
    final user = AppUser(
      id: _userIdFromEmail(normalizedEmail),
      displayName: namePart.isEmpty
          ? 'You'
          : namePart[0].toUpperCase() + namePart.substring(1),
    );
    _currentUser = user;
    return user;
  }

  String _userIdFromEmail(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    return 'user-${normalizedEmail.hashCode}';
  }
}

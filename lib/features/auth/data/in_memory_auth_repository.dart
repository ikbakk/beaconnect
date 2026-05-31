import '../domain/app_user.dart';
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
    final normalizedEmail = email.trim().toLowerCase();
    final namePart = normalizedEmail.split('@').first;
    _currentUser ??= AppUser(
      id: 'user-${normalizedEmail.hashCode}',
      displayName: namePart.isEmpty
          ? 'You'
          : namePart[0].toUpperCase() + namePart.substring(1),
    );
    return _currentUser!;
  }
}

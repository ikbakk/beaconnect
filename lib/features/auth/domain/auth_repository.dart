import 'app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> getCurrentUser();
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });
}

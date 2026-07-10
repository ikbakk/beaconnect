import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_user.dart';
import '../domain/auth_failure.dart';
import '../domain/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._preferences);

  static const _userKey = 'auth.current_user';

  final SharedPreferences _preferences;

  @override
  Future<AppUser?> getCurrentUser() async {
    final raw = _preferences.getString(_userKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final currentUser = await getCurrentUser();
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
    final displayName = namePart.isEmpty ? 'You' : _toDisplayName(namePart);
    final user = AppUser(
      id: _userIdFromEmail(normalizedEmail),
      displayName: displayName,
    );
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  String _userIdFromEmail(String email) {
    final normalizedEmail = email.trim().toLowerCase();
    return 'user-${normalizedEmail.hashCode}';
  }

  String _toDisplayName(String value) {
    if (value.isEmpty) {
      return 'You';
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}

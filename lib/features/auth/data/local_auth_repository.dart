import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_user.dart';
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
  Future<AppUser> signInWithGoogle() async {
    final user = const AppUser(
      id: 'user-1',
      displayName: 'Iqbal',
    );
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }
}

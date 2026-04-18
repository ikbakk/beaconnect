import 'package:shared_preferences/shared_preferences.dart';

import '../domain/request_check_in_repository.dart';

class LocalRequestCheckInRepository implements RequestCheckInRepository {
  LocalRequestCheckInRepository(this._preferences);

  static const _lastRequestKey = 'request_check_in.last_sent_at';

  final SharedPreferences _preferences;

  @override
  Future<DateTime?> getLastRequestAt() async {
    final raw = _preferences.getString(_lastRequestKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  @override
  Future<void> saveLastRequestAt(DateTime timestamp) {
    return _preferences.setString(_lastRequestKey, timestamp.toIso8601String());
  }
}

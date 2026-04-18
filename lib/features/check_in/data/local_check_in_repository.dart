import 'package:shared_preferences/shared_preferences.dart';

import '../domain/check_in_repository.dart';

class LocalCheckInRepository implements CheckInRepository {
  LocalCheckInRepository(this._preferences);

  static const _lastCheckInKey = 'check_in.last_sent_at';

  final SharedPreferences _preferences;

  @override
  Future<DateTime?> getLastCheckInAt() async {
    final raw = _preferences.getString(_lastCheckInKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
  }

  @override
  Future<void> saveLastCheckInAt(DateTime timestamp) {
    return _preferences.setString(_lastCheckInKey, timestamp.toIso8601String());
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/battery_saver_repository.dart';

class LocalBatterySaverRepository implements BatterySaverRepository {
  LocalBatterySaverRepository(this._preferences);

  static const _key = 'battery_saver.enabled';

  final SharedPreferences _preferences;

  @override
  Future<bool> isEnabled() async {
    return _preferences.getBool(_key) ?? false;
  }

  @override
  Future<bool> setEnabled(bool enabled) async {
    await _preferences.setBool(_key, enabled);
    return enabled;
  }
}

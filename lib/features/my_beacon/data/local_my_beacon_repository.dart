import 'package:shared_preferences/shared_preferences.dart';

import '../domain/my_beacon_preferences.dart';
import '../domain/my_beacon_repository.dart';

class LocalMyBeaconRepository implements MyBeaconRepository {
  LocalMyBeaconRepository(this._preferences);

  static const _pairSymbolKey = 'my_beacon.pair_symbol';
  static const _checkInMessageKey = 'my_beacon.check_in_message';

  final SharedPreferences _preferences;

  @override
  Future<MyBeaconPreferences> getPreferences() async {
    return MyBeaconPreferences(
      pairSymbol: _preferences.getString(_pairSymbolKey) ?? '★',
      checkInMessage:
          _preferences.getString(_checkInMessageKey) ??
          'let {partner} know they are around.',
    );
  }

  @override
  Future<MyBeaconPreferences> savePreferences(
    MyBeaconPreferences preferences,
  ) async {
    await _preferences.setString(_pairSymbolKey, preferences.pairSymbol);
    await _preferences.setString(_checkInMessageKey, preferences.checkInMessage);
    return preferences;
  }
}

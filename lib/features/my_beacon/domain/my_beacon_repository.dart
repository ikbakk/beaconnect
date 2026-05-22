import 'my_beacon_preferences.dart';

abstract class MyBeaconRepository {
  Future<MyBeaconPreferences> getPreferences();
  Future<MyBeaconPreferences> savePreferences(MyBeaconPreferences preferences);
}

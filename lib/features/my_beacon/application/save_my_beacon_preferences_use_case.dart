import '../domain/my_beacon_preferences.dart';
import '../domain/my_beacon_repository.dart';

class SaveMyBeaconPreferencesUseCase {
  const SaveMyBeaconPreferencesUseCase(this._repository);

  final MyBeaconRepository _repository;

  Future<MyBeaconPreferences> call(MyBeaconPreferences preferences) {
    return _repository.savePreferences(preferences);
  }
}

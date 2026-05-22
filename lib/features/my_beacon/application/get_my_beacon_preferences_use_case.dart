import '../domain/my_beacon_preferences.dart';
import '../domain/my_beacon_repository.dart';

class GetMyBeaconPreferencesUseCase {
  const GetMyBeaconPreferencesUseCase(this._repository);

  final MyBeaconRepository _repository;

  Future<MyBeaconPreferences> call() {
    return _repository.getPreferences();
  }
}

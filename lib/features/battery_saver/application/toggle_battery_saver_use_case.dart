import '../domain/battery_saver_repository.dart';

class ToggleBatterySaverUseCase {
  const ToggleBatterySaverUseCase(this._repository);

  final BatterySaverRepository _repository;

  Future<bool> call(bool enabled) {
    return _repository.setEnabled(enabled);
  }
}

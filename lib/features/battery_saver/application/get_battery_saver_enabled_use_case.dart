import '../domain/battery_saver_repository.dart';

class GetBatterySaverEnabledUseCase {
  const GetBatterySaverEnabledUseCase(this._repository);

  final BatterySaverRepository _repository;

  Future<bool> call() {
    return _repository.isEnabled();
  }
}

abstract class BatterySaverRepository {
  Future<bool> isEnabled();
  Future<bool> setEnabled(bool enabled);
}

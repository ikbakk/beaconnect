abstract class CheckInRepository {
  Future<DateTime?> getLastCheckInAt();
  Future<void> saveLastCheckInAt(DateTime timestamp);
}

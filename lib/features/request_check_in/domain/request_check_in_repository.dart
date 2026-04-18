abstract class RequestCheckInRepository {
  Future<DateTime?> getLastRequestAt();
  Future<void> saveLastRequestAt(DateTime timestamp);
}

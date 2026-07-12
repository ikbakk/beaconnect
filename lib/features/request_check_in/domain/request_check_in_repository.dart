abstract class RequestCheckInRepository {
  Future<DateTime?> getLastRequestAt();

  Future<void> createRequest({
    required DateTime createdAt,
    required String requesterUserId,
    required String requesterName,
    required String partnerUserId,
  });

  Future<bool> respondToLatestIncomingRequest({
    required String responderUserId,
    required String response,
  });
}

import 'live_sharing_session.dart';

abstract class LiveSharingRepository {
  Future<LiveSharingSession?> getCurrentSession();
  Future<LiveSharingSession> start({
    required int minutes,
    String? reason,
  });
  Future<LiveSharingSession?> pause();
  Future<void> end();
}

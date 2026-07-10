import '../../../app/providers.dart';
import '../../../core/permissions/domain/permission_repository.dart';
import '../../live_sharing/domain/live_sharing_repository.dart';
import '../../live_sharing/domain/live_sharing_session.dart';
import '../../my_beacon/domain/my_beacon_repository.dart';
import '../../place_snapshot/domain/place_snapshot.dart';
import '../../place_snapshot/domain/place_snapshot_repository.dart';
import '../../updates/domain/updates_repository.dart';
import '../domain/home_repository.dart';
import '../domain/home_snapshot.dart';
import '../domain/home_state_variant.dart';
import '../domain/partner_summary.dart';

class LocalHomeRepository implements HomeRepository {
  LocalHomeRepository(
    this._session,
    this._updatesRepository,
    this._permissionRepository,
    this._placeSnapshotRepository,
    this._liveSharingRepository,
    this._myBeaconRepository,
  );

  final AppSessionState _session;
  final UpdatesRepository _updatesRepository;
  final PermissionRepository _permissionRepository;
  final PlaceSnapshotRepository _placeSnapshotRepository;
  final LiveSharingRepository _liveSharingRepository;
  final MyBeaconRepository _myBeaconRepository;

  @override
  Future<HomeSnapshot> getSnapshot() async {
    final updates = await _updatesRepository.getUpdates();
    final permissionStatus = await _permissionRepository.getStatus();
    final placeSnapshot = await _placeSnapshotRepository.getLatestSnapshot();
    final liveSession = await _liveSharingRepository.getCurrentSession();
    final beaconPrefs = await _myBeaconRepository.getPreferences();
    final partnerName = _partnerName(beaconPrefs.pairSymbol);
    final recentUpdates = updates.take(2).toList();

    if (!_session.hasPartner) {
      return HomeSnapshot(
        variant: HomeStateVariant.noPartner,
        partnerSummary: const PartnerSummary(
          name: 'Welcome.',
          statusSentence:
              'Beaconnect works best when both people choose to share.',
          freshnessSentence: 'Pair with someone to get started.',
        ),
        updates: const [],
        placeSnapshot: placeSnapshot,
      );
    }

    if (liveSession != null) {
      return HomeSnapshot(
        variant: liveSession.isPaused
            ? HomeStateVariant.sharingPaused
            : HomeStateVariant.liveSharing,
        partnerSummary: PartnerSummary(
          name: partnerName,
          statusSentence: liveSession.isPaused
              ? 'Sharing is currently paused.'
              : 'Sharing live.',
          freshnessSentence: liveSession.isPaused
              ? _pausedFreshnessSentence(placeSnapshot)
              : _liveFreshnessSentence(liveSession),
        ),
        updates: recentUpdates,
        placeSnapshot: placeSnapshot,
      );
    }

    if (!permissionStatus.isReadyForSharing) {
      return HomeSnapshot(
        variant: HomeStateVariant.permissionMissing,
        partnerSummary: PartnerSummary(
          name: partnerName,
          statusSentence: 'Sharing is not fully available yet.',
          freshnessSentence:
              'Background sharing works best when permission is enabled.',
        ),
        updates: recentUpdates,
        placeSnapshot: placeSnapshot,
      );
    }

    if (updates.isEmpty) {
      return HomeSnapshot(
        variant: HomeStateVariant.noNewUpdates,
        partnerSummary: PartnerSummary(
          name: partnerName,
          statusSentence: 'No new updates yet.',
          freshnessSentence: _freshnessSentence(
            placeSnapshot,
            emptyState: true,
          ),
        ),
        updates: const [],
        placeSnapshot: placeSnapshot,
      );
    }

    return HomeSnapshot(
      variant: HomeStateVariant.normal,
      partnerSummary: PartnerSummary(
        name: partnerName,
        statusSentence: 'Everything looks normal.',
        freshnessSentence: _freshnessSentence(placeSnapshot),
      ),
      updates: recentUpdates,
      placeSnapshot: placeSnapshot,
    );
  }

  String _partnerName(String pairSymbol) {
    final baseName = _session.currentPair?.partnerDisplayName ?? 'Your partner';
    return '$baseName $pairSymbol'.trim();
  }

  String _liveFreshnessSentence(LiveSharingSession liveSession) {
    final reason = liveSession.reason;
    if (reason == null || reason.isEmpty) {
      return '${liveSession.minutesRemaining} minutes remaining.';
    }

    return '$reason. ${liveSession.minutesRemaining} minutes remaining.';
  }

  String _pausedFreshnessSentence(PlaceSnapshot? placeSnapshot) {
    if (placeSnapshot == null) {
      return 'Sharing can resume whenever both people are ready.';
    }

    final time = placeSnapshot.capturedAt;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return 'Last update was today at $hour:$minute.';
  }

  String _freshnessSentence(
    PlaceSnapshot? placeSnapshot, {
    bool emptyState = false,
  }) {
    if (placeSnapshot == null) {
      return emptyState
          ? 'No current place yet.'
          : 'Showing your most recent update.';
    }

    final minutesAgo = DateTime.now().difference(placeSnapshot.capturedAt).inMinutes;
    final label = placeSnapshot.placeLabel;

    if (minutesAgo <= 0) {
      return emptyState
          ? 'Last updated just now near $label.'
          : 'Updated just now at $label.';
    }

    if (minutesAgo < 10) {
      return emptyState
          ? 'Last updated $minutesAgo minutes ago near $label.'
          : 'Updated $minutesAgo minutes ago at $label.';
    }

    return emptyState
        ? 'Last updated $minutesAgo minutes ago near $label.'
        : 'Updated recently at $label.';
  }
}

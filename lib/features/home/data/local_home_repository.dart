import '../../../app/providers.dart';
import '../../../core/permissions/domain/permission_repository.dart';
import '../../live_sharing/domain/live_sharing_repository.dart';
import '../../my_beacon/domain/my_beacon_repository.dart';
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
    final partnerName = 'Sarah ${beaconPrefs.pairSymbol}'.trim();

    if (!_session.hasPartner) {
      return HomeSnapshot(
        variant: HomeStateVariant.noPartner,
        partnerSummary: const PartnerSummary(
          name: 'Welcome.',
          statusSentence:
              'Beaconnect works best when both people choose to share.',
          freshnessSentence: 'Pair when you are ready.',
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
          statusSentence: liveSession.isPaused ? 'Sharing paused.' : 'Sharing live.',
          freshnessSentence: liveSession.reason == null || liveSession.reason!.isEmpty
              ? '${liveSession.minutesRemaining} minutes remaining.'
              : '${liveSession.reason}. ${liveSession.minutesRemaining} minutes remaining.',
        ),
        updates: updates.take(2).toList(),
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
        updates: updates.take(2).toList(),
        placeSnapshot: placeSnapshot,
      );
    }

    if (updates.isEmpty) {
      return HomeSnapshot(
        variant: HomeStateVariant.noNewUpdates,
        partnerSummary: PartnerSummary(
          name: partnerName,
          statusSentence: 'No new updates yet.',
          freshnessSentence: placeSnapshot == null
              ? 'Last updated 47 minutes ago near Home.'
              : 'Showing your most recent update from ${placeSnapshot.placeLabel}.',
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
        freshnessSentence: placeSnapshot == null
            ? 'Updated 2 minutes ago at Home.'
            : 'Updated recently at ${placeSnapshot.placeLabel}.',
      ),
      updates: updates.take(2).toList(),
      placeSnapshot: placeSnapshot,
    );
  }
}

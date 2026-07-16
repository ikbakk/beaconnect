import 'package:flutter_test/flutter_test.dart';

import 'package:beaconnect/app/providers.dart';
import 'package:beaconnect/core/permissions/domain/permission_repository.dart';
import 'package:beaconnect/core/permissions/domain/permission_status.dart';
import 'package:beaconnect/features/auth/domain/app_user.dart';
import 'package:beaconnect/features/home/data/local_home_repository.dart';
import 'package:beaconnect/features/home/domain/home_state_variant.dart';
import 'package:beaconnect/features/live_sharing/domain/live_sharing_repository.dart';
import 'package:beaconnect/features/live_sharing/domain/live_sharing_session.dart';
import 'package:beaconnect/features/my_beacon/domain/my_beacon_preferences.dart';
import 'package:beaconnect/features/my_beacon/domain/my_beacon_repository.dart';
import 'package:beaconnect/features/pairing/domain/pair_record.dart';
import 'package:beaconnect/features/place_snapshot/domain/place_snapshot.dart';
import 'package:beaconnect/features/place_snapshot/domain/place_snapshot_repository.dart';
import 'package:beaconnect/features/updates/domain/update_story.dart';
import 'package:beaconnect/features/updates/domain/updates_repository.dart';

void main() {
  test('uses the active partner name and symbol in the summary', () async {
    final repository = LocalHomeRepository(
      const AppSessionState(
        hasCompletedOnboarding: true,
        hasPartner: true,
        currentUser: AppUser(id: 'user-1', displayName: 'Iqbal'),
        currentPair: PairRecord(
          id: 'pair-1',
          memberIds: ['user-1', 'user-2'],
          status: 'active',
          inviteCode: 'BEACON',
          partnerDisplayName: 'Asha',
          expiresInMinutes: 5,
        ),
      ),
      _FakeUpdatesRepository(
        updates: const [
          UpdateStory(
            timeGroup: 'Just now',
            title: 'Checked in',
            story: 'Asha let you know they are around.',
            place: 'Home',
          ),
        ],
      ),
      const _FakePermissionRepository(
        PermissionStatus(
          locationSharingEnabled: true,
          notificationsEnabled: true,
        ),
      ),
      _FakePlaceSnapshotRepository(
        PlaceSnapshot(
          placeLabel: 'Home',
          capturedAt: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ),
      const _FakeLiveSharingRepository(),
      const _FakeMyBeaconRepository(
        MyBeaconPreferences(
          pairSymbol: '★',
          checkInMessage: 'let {partner} know they are around.',
        ),
      ),
    );

    final snapshot = await repository.getSnapshot();

    expect(snapshot.variant, HomeStateVariant.normal);
    // The repository owns the partner name; the pair symbol is a separate
    // field on `PartnerSummary` so the card can render it in its intended
    // visual position without re-concatenating into the name (A9).
    expect(snapshot.partnerSummary.name, 'Asha');
    expect(snapshot.partnerSummary.pairSymbol, '★');
  });

  test('does not invent updates for a newly connected home snapshot', () async {
    final repository = LocalHomeRepository(
      const AppSessionState(
        hasCompletedOnboarding: true,
        hasPartner: true,
        currentUser: AppUser(id: 'user-1', displayName: 'Iqbal'),
        currentPair: PairRecord(
          id: 'pair-1',
          memberIds: ['user-1', 'user-2'],
          status: 'active',
          inviteCode: 'BEACON',
          partnerDisplayName: 'Sarah',
          expiresInMinutes: 5,
        ),
      ),
      _FakeUpdatesRepository(updates: const []),
      const _FakePermissionRepository(
        PermissionStatus(
          locationSharingEnabled: true,
          notificationsEnabled: true,
        ),
      ),
      _FakePlaceSnapshotRepository(null),
      const _FakeLiveSharingRepository(),
      const _FakeMyBeaconRepository(
        MyBeaconPreferences(
          pairSymbol: '★',
          checkInMessage: 'let {partner} know they are around.',
        ),
      ),
    );

    final snapshot = await repository.getSnapshot();

    expect(snapshot.variant, HomeStateVariant.noNewUpdates);
    expect(snapshot.updates, isEmpty);
    expect(snapshot.partnerSummary.freshnessSentence, 'No current place yet.');
  });
}

class _FakePermissionRepository implements PermissionRepository {
  const _FakePermissionRepository(this._status);

  final PermissionStatus _status;

  @override
  Future<PermissionStatus> enableEducationState() async {
    return _status;
  }

  @override
  Future<PermissionStatus> getStatus() async {
    return _status;
  }
}

class _FakePlaceSnapshotRepository implements PlaceSnapshotRepository {
  const _FakePlaceSnapshotRepository(this._snapshot);

  final PlaceSnapshot? _snapshot;

  @override
  Future<PlaceSnapshot> captureSnapshot() async {
    return _snapshot!;
  }

  @override
  Future<PlaceSnapshot?> getLatestSnapshot() async {
    return _snapshot;
  }
}

class _FakeLiveSharingRepository implements LiveSharingRepository {
  const _FakeLiveSharingRepository();

  @override
  Future<void> end() async {}

  @override
  Future<LiveSharingSession?> getCurrentSession() async {
    return null;
  }

  @override
  Future<LiveSharingSession?> pause() async {
    return null;
  }

  @override
  Future<LiveSharingSession?> resume() async {
    return null;
  }

  @override
  Future<LiveSharingSession> start({required int minutes, String? reason}) {
    throw UnimplementedError();
  }
}

class _FakeMyBeaconRepository implements MyBeaconRepository {
  const _FakeMyBeaconRepository(this._preferences);

  final MyBeaconPreferences _preferences;

  @override
  Future<MyBeaconPreferences> getPreferences() async {
    return _preferences;
  }

  @override
  Future<MyBeaconPreferences> savePreferences(
    MyBeaconPreferences preferences,
  ) async {
    return preferences;
  }
}

class _FakeUpdatesRepository implements UpdatesRepository {
  const _FakeUpdatesRepository({required this.updates});

  final List<UpdateStory> updates;

  @override
  Future<void> addUpdate(UpdateStory update) async {}

  @override
  Future<List<UpdateStory>> getUpdates() async {
    return updates;
  }

  @override
  Future<void> saveUpdates(List<UpdateStory> updates) async {}
}

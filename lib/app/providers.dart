import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/config/app_data_source.dart';
import '../core/permissions/application/enable_permission_education_use_case.dart';
import '../core/permissions/application/get_permission_status_use_case.dart';
import '../core/permissions/data/local_permission_repository.dart';
import '../core/permissions/domain/permission_repository.dart';
import '../core/permissions/domain/permission_status.dart';
import '../features/auth/application/load_current_user_use_case.dart';
import '../features/auth/application/sign_in_with_email_use_case.dart';
import '../features/auth/application/sign_up_with_email_use_case.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/data/local_auth_repository.dart';
import '../features/auth/domain/app_user.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/battery_saver/application/get_battery_saver_enabled_use_case.dart';
import '../features/battery_saver/application/toggle_battery_saver_use_case.dart';
import '../features/battery_saver/data/local_battery_saver_repository.dart';
import '../features/battery_saver/domain/battery_saver_repository.dart';
import '../features/check_in/application/send_check_in_use_case.dart';
import '../features/check_in/data/firebase_check_in_repository.dart';
import '../features/check_in/data/local_check_in_repository.dart';
import '../features/check_in/domain/check_in_repository.dart';
import '../features/home/application/get_home_snapshot_use_case.dart';
import '../features/home/data/local_home_repository.dart';
import '../features/home/domain/home_repository.dart';
import '../features/home/domain/home_snapshot.dart';
import '../features/live_sharing/data/local_live_sharing_repository.dart';
import '../features/live_sharing/domain/live_sharing_repository.dart';
import '../features/my_beacon/application/get_my_beacon_preferences_use_case.dart';
import '../features/my_beacon/application/save_my_beacon_preferences_use_case.dart';
import '../features/my_beacon/data/local_my_beacon_repository.dart';
import '../features/my_beacon/domain/my_beacon_preferences.dart';
import '../features/my_beacon/domain/my_beacon_repository.dart';
import '../features/pairing/application/approve_pairing_use_case.dart';
import '../features/pairing/application/create_invite_code_use_case.dart';
import '../features/pairing/application/load_current_pair_use_case.dart';
import '../features/pairing/application/skip_pairing_use_case.dart';
import '../features/pairing/data/firebase_pairing_repository.dart';
import '../features/pairing/data/local_pairing_repository.dart';
import '../features/pairing/domain/pair_record.dart';
import '../features/pairing/domain/pairing_repository.dart';
import '../features/place_snapshot/application/capture_place_snapshot_use_case.dart';
import '../features/place_snapshot/application/get_latest_place_snapshot_use_case.dart';
import '../features/place_snapshot/data/local_place_snapshot_repository.dart';
import '../features/place_snapshot/domain/place_snapshot.dart';
import '../features/place_snapshot/domain/place_snapshot_repository.dart';
import '../features/request_check_in/application/send_request_check_in_use_case.dart';
import '../features/request_check_in/data/local_request_check_in_repository.dart';
import '../features/request_check_in/domain/request_check_in_repository.dart';
import '../features/updates/application/add_update_use_case.dart';
import '../features/updates/application/get_updates_use_case.dart';
import '../features/updates/data/firebase_updates_repository.dart';
import '../features/updates/data/local_updates_repository.dart';
import '../features/updates/domain/update_story.dart';
import '../features/updates/domain/updates_repository.dart';
import 'bootstrap_state.dart';

const onboardingCompletePreferenceKey = 'app.onboarding_complete';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('SharedPreferences must be overridden in bootstrap.'),
);

final bootstrapStateProvider = Provider<BootstrapState>(
  (ref) => const BootstrapState(
    currentUser: null,
    currentPair: null,
    hasCompletedOnboarding: false,
    latestPlaceSnapshot: null,
  ),
);

final appConfigProvider = Provider<AppConfig>(
  (ref) => const AppConfig(dataSource: AppDataSource.local),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return switch (config.dataSource) {
    AppDataSource.local => LocalAuthRepository(ref.watch(sharedPreferencesProvider)),
    AppDataSource.firebase => FirebaseAuthRepository(),
  };
});

final pairingRepositoryProvider = Provider<PairingRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final currentUserId = ref.watch(currentUserProvider)?.id;
  return switch (config.dataSource) {
    AppDataSource.local => LocalPairingRepository(ref.watch(sharedPreferencesProvider)),
    AppDataSource.firebase => FirebasePairingRepository(currentUserId: currentUserId),
  };
});

final updatesRepositoryProvider = Provider<UpdatesRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final pairId = ref.watch(currentPairProvider)?.id;
  final currentUserId = ref.watch(currentUserProvider)?.id;
  return switch (config.dataSource) {
    AppDataSource.local => LocalUpdatesRepository(ref.watch(sharedPreferencesProvider)),
    AppDataSource.firebase => FirebaseUpdatesRepository(
      pairId: pairId,
      currentUserId: currentUserId,
    ),
  };
});

final permissionRepositoryProvider = Provider<PermissionRepository>(
  (ref) => LocalPermissionRepository(ref.watch(sharedPreferencesProvider)),
);

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  final currentUserId = ref.watch(currentUserProvider)?.id;
  return switch (config.dataSource) {
    AppDataSource.local => LocalCheckInRepository(ref.watch(sharedPreferencesProvider)),
    AppDataSource.firebase => FirebaseCheckInRepository(currentUserId: currentUserId),
  };
});

final requestCheckInRepositoryProvider = Provider<RequestCheckInRepository>(
  (ref) => LocalRequestCheckInRepository(ref.watch(sharedPreferencesProvider)),
);

final placeSnapshotRepositoryProvider = Provider<PlaceSnapshotRepository>(
  (ref) => LocalPlaceSnapshotRepository(ref.watch(sharedPreferencesProvider)),
);

final liveSharingRepositoryProvider = Provider<LiveSharingRepository>(
  (ref) => LocalLiveSharingRepository(ref.watch(sharedPreferencesProvider)),
);

final batterySaverRepositoryProvider = Provider<BatterySaverRepository>(
  (ref) => LocalBatterySaverRepository(ref.watch(sharedPreferencesProvider)),
);

final myBeaconRepositoryProvider = Provider<MyBeaconRepository>(
  (ref) => LocalMyBeaconRepository(ref.watch(sharedPreferencesProvider)),
);

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => LocalHomeRepository(
    ref.watch(appSessionProvider),
    ref.watch(updatesRepositoryProvider),
    ref.watch(permissionRepositoryProvider),
    ref.watch(placeSnapshotRepositoryProvider),
    ref.watch(liveSharingRepositoryProvider),
    ref.watch(myBeaconRepositoryProvider),
  ),
);

final loadCurrentUserUseCaseProvider = Provider<LoadCurrentUserUseCase>(
  (ref) => LoadCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);
final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>(
  (ref) => SignInWithEmailUseCase(ref.watch(authRepositoryProvider)),
);
final signUpWithEmailUseCaseProvider = Provider<SignUpWithEmailUseCase>(
  (ref) => SignUpWithEmailUseCase(ref.watch(authRepositoryProvider)),
);
final loadCurrentPairUseCaseProvider = Provider<LoadCurrentPairUseCase>(
  (ref) => LoadCurrentPairUseCase(ref.watch(pairingRepositoryProvider)),
);
final createInviteCodeUseCaseProvider = Provider<CreateInviteCodeUseCase>(
  (ref) => CreateInviteCodeUseCase(ref.watch(pairingRepositoryProvider)),
);
final approvePairingUseCaseProvider = Provider<ApprovePairingUseCase>(
  (ref) => ApprovePairingUseCase(ref.watch(pairingRepositoryProvider)),
);
final skipPairingUseCaseProvider = Provider<SkipPairingUseCase>(
  (ref) => SkipPairingUseCase(ref.watch(pairingRepositoryProvider)),
);
final getUpdatesUseCaseProvider = Provider<GetUpdatesUseCase>(
  (ref) => GetUpdatesUseCase(ref.watch(updatesRepositoryProvider)),
);
final addUpdateUseCaseProvider = Provider<AddUpdateUseCase>(
  (ref) => AddUpdateUseCase(ref.watch(updatesRepositoryProvider)),
);
final getPermissionStatusUseCaseProvider = Provider<GetPermissionStatusUseCase>(
  (ref) => GetPermissionStatusUseCase(ref.watch(permissionRepositoryProvider)),
);
final enablePermissionEducationUseCaseProvider = Provider<EnablePermissionEducationUseCase>(
  (ref) => EnablePermissionEducationUseCase(ref.watch(permissionRepositoryProvider)),
);
final sendCheckInUseCaseProvider = Provider<SendCheckInUseCase>(
  (ref) => SendCheckInUseCase(
    ref.watch(checkInRepositoryProvider),
    ref.watch(addUpdateUseCaseProvider),
    ref.watch(myBeaconRepositoryProvider),
  ),
);
final sendRequestCheckInUseCaseProvider = Provider<SendRequestCheckInUseCase>(
  (ref) => SendRequestCheckInUseCase(
    ref.watch(requestCheckInRepositoryProvider),
    ref.watch(addUpdateUseCaseProvider),
  ),
);
final getHomeSnapshotUseCaseProvider = Provider<GetHomeSnapshotUseCase>(
  (ref) => GetHomeSnapshotUseCase(ref.watch(homeRepositoryProvider)),
);
final getLatestPlaceSnapshotUseCaseProvider = Provider<GetLatestPlaceSnapshotUseCase>(
  (ref) => GetLatestPlaceSnapshotUseCase(ref.watch(placeSnapshotRepositoryProvider)),
);
final capturePlaceSnapshotUseCaseProvider = Provider<CapturePlaceSnapshotUseCase>(
  (ref) => CapturePlaceSnapshotUseCase(
    ref.watch(placeSnapshotRepositoryProvider),
    ref.watch(addUpdateUseCaseProvider),
  ),
);
final getBatterySaverEnabledUseCaseProvider = Provider<GetBatterySaverEnabledUseCase>(
  (ref) => GetBatterySaverEnabledUseCase(ref.watch(batterySaverRepositoryProvider)),
);
final toggleBatterySaverUseCaseProvider = Provider<ToggleBatterySaverUseCase>(
  (ref) => ToggleBatterySaverUseCase(ref.watch(batterySaverRepositoryProvider)),
);
final getMyBeaconPreferencesUseCaseProvider = Provider<GetMyBeaconPreferencesUseCase>(
  (ref) => GetMyBeaconPreferencesUseCase(ref.watch(myBeaconRepositoryProvider)),
);
final saveMyBeaconPreferencesUseCaseProvider = Provider<SaveMyBeaconPreferencesUseCase>(
  (ref) => SaveMyBeaconPreferencesUseCase(ref.watch(myBeaconRepositoryProvider)),
);

final currentUserProvider = StateProvider<AppUser?>(
  (ref) => ref.watch(bootstrapStateProvider).currentUser,
);
final currentPairProvider = StateProvider<PairRecord?>(
  (ref) => ref.watch(bootstrapStateProvider).currentPair,
);
final onboardingCompletedProvider = StateProvider<bool>(
  (ref) => ref.watch(bootstrapStateProvider).hasCompletedOnboarding,
);

final permissionStatusProvider = FutureProvider<PermissionStatus>(
  (ref) => ref.watch(getPermissionStatusUseCaseProvider).call(),
);
final updatesProvider = FutureProvider<List<UpdateStory>>(
  (ref) => ref.watch(getUpdatesUseCaseProvider).call(),
);
final latestPlaceSnapshotProvider = FutureProvider<PlaceSnapshot?>(
  (ref) => ref.watch(getLatestPlaceSnapshotUseCaseProvider).call(),
);
final homeSnapshotProvider = FutureProvider<HomeSnapshot>(
  (ref) => ref.watch(getHomeSnapshotUseCaseProvider).call(),
);
final batterySaverEnabledProvider = FutureProvider<bool>(
  (ref) => ref.watch(getBatterySaverEnabledUseCaseProvider).call(),
);
final myBeaconPreferencesProvider = FutureProvider<MyBeaconPreferences>(
  (ref) => ref.watch(getMyBeaconPreferencesUseCaseProvider).call(),
);

final appSessionProvider = Provider<AppSessionState>((ref) {
  final user = ref.watch(currentUserProvider);
  final pair = ref.watch(currentPairProvider);
  final hasCompletedOnboarding = ref.watch(onboardingCompletedProvider);
  return AppSessionState(
    hasCompletedOnboarding: hasCompletedOnboarding,
    hasPartner: pair?.status == 'active',
    currentUser: user,
    currentPair: pair,
  );
});

@immutable
class AppSessionState {
  const AppSessionState({
    required this.hasCompletedOnboarding,
    required this.hasPartner,
    required this.currentUser,
    required this.currentPair,
  });

  final bool hasCompletedOnboarding;
  final bool hasPartner;
  final AppUser? currentUser;
  final PairRecord? currentPair;
}

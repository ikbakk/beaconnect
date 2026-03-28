import '../features/auth/domain/app_user.dart';
import '../features/pairing/domain/pair_record.dart';
import '../features/place_snapshot/domain/place_snapshot.dart';

class BootstrapState {
  const BootstrapState({
    required this.currentUser,
    required this.currentPair,
    required this.hasCompletedOnboarding,
    required this.latestPlaceSnapshot,
  });

  final AppUser? currentUser;
  final PairRecord? currentPair;
  final bool hasCompletedOnboarding;
  final PlaceSnapshot? latestPlaceSnapshot;
}

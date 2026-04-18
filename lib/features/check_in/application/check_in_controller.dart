import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/check_in_status.dart';

final checkInControllerProvider =
    StateNotifierProvider<CheckInController, CheckInState>(
      (ref) => CheckInController(ref),
    );

@immutable
class CheckInState {
  const CheckInState({required this.status});

  final CheckInStatus status;

  bool get isBusy => status == CheckInStatus.sending;
}

class CheckInController extends StateNotifier<CheckInState> {
  CheckInController(this._ref)
    : super(const CheckInState(status: CheckInStatus.idle));

  final Ref _ref;

  Future<void> sendCheckIn() async {
    if (state.isBusy) {
      return;
    }

    final session = _ref.read(appSessionProvider);
    final currentUser = session.currentUser;
    final currentPair = session.currentPair;

    if (currentUser == null || currentPair == null) {
      state = const CheckInState(status: CheckInStatus.cooldown);
      return;
    }

    state = const CheckInState(status: CheckInStatus.sending);
    final result = await _ref.read(sendCheckInUseCaseProvider).call(
      senderName: currentUser.displayName,
      partnerName: currentPair.partnerDisplayName,
    );
    _ref.invalidate(updatesProvider);
    _ref.invalidate(homeSnapshotProvider);

    if (result.enteredCooldown) {
      state = const CheckInState(status: CheckInStatus.cooldown);
      return;
    }

    state = const CheckInState(status: CheckInStatus.success);
  }

  void reset() {
    state = const CheckInState(status: CheckInStatus.idle);
  }
}

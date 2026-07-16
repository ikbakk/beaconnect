import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/check_in_status.dart';

final checkInControllerProvider =
    StateNotifierProvider<CheckInController, CheckInState>(
      (ref) => CheckInController(ref),
    );

@immutable
class CheckInState {
  const CheckInState({
    required this.status,
    required this.partnerName,
    required this.idleLabel,
    this.message,
  });

  final CheckInStatus status;
  final String partnerName;

  /// The user-facing button label while idle. Sourced from
  /// `MyBeaconPreferences.checkInMessage` so the user can personalize the
  /// check-in copy in My Beacon. Falls back to the canonical "I'm Okay".
  final String idleLabel;

  final String? message;

  bool get isBusy => status == CheckInStatus.sending;
}

class CheckInController extends StateNotifier<CheckInState> {
  CheckInController(this._ref)
    : super(
        CheckInState(
          status: CheckInStatus.idle,
          partnerName: 'your partner',
          idleLabel: _resolveIdleLabel(_ref),
        ),
      );

  final Ref _ref;

  /// Pulls the user-saved check-in message from the cached My Beacon
  /// preferences. Returns the canonical "I'm Okay" if the preferences
  /// haven't loaded yet (cold start).
  static String _resolveIdleLabel(Ref ref) {
    final cached = ref.read(myBeaconPreferencesProvider).valueOrNull;
    return _sanitizeIdleLabel(cached?.checkInMessage);
  }

  static String _sanitizeIdleLabel(String? raw) {
    if (raw == null) return "I'm Okay";
    final trimmed = raw.trim();
    return trimmed.isEmpty ? "I'm Okay" : trimmed;
  }

  Future<void> sendCheckIn() async {
    if (state.isBusy) {
      return;
    }

    final session = _ref.read(appSessionProvider);
    final currentUser = session.currentUser;
    final currentPair = session.currentPair;

    if (currentUser == null || currentPair == null) {
      state = CheckInState(
        status: CheckInStatus.unavailable,
        partnerName: 'your partner',
        idleLabel: state.idleLabel,
        message: 'Check-ins work best after you pair first.',
      );
      return;
    }

    state = CheckInState(
      status: CheckInStatus.sending,
      partnerName: currentPair.partnerDisplayName,
      idleLabel: state.idleLabel,
    );
    final result = await _ref.read(sendCheckInUseCaseProvider).call(
      senderUserId: currentUser.id,
      senderName: currentUser.displayName,
      partnerName: currentPair.partnerDisplayName,
    );
    _ref.invalidate(updatesProvider);
    _ref.invalidate(homeSnapshotProvider);

    if (result.enteredCooldown) {
      state = CheckInState(
        status: CheckInStatus.cooldown,
        partnerName: currentPair.partnerDisplayName,
        idleLabel: state.idleLabel,
        message: result.message,
      );
      return;
    }

    state = CheckInState(
      status: CheckInStatus.success,
      partnerName: currentPair.partnerDisplayName,
      idleLabel: state.idleLabel,
      message: result.message,
    );
    // Tiny confirmation haptic. See interaction-language.md:
    // "Haptics: Use sparingly. Check-in: tiny confirmation."
    HapticFeedback.lightImpact();
  }

  /// Re-read the user-saved check-in message so changes made in My Beacon
  /// are reflected on the home button the next time it is observed.
  void refreshIdleLabel() {
    final next = _resolveIdleLabel(_ref);
    if (next == state.idleLabel) return;
    state = CheckInState(
      status: state.status,
      partnerName: state.partnerName,
      idleLabel: next,
      message: state.message,
    );
  }

  void reset() {
    state = CheckInState(
      status: CheckInStatus.idle,
      partnerName: state.partnerName,
      idleLabel: _resolveIdleLabel(_ref),
    );
  }
}

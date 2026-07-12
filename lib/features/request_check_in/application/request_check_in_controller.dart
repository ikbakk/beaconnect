import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

final requestCheckInControllerProvider =
    StateNotifierProvider<RequestCheckInController, RequestCheckInState>(
      (ref) => RequestCheckInController(ref),
    );

@immutable
class RequestCheckInState {
  const RequestCheckInState({
    required this.isSending,
    required this.lastMessage,
  });

  final bool isSending;
  final String? lastMessage;
}

class RequestCheckInController extends StateNotifier<RequestCheckInState> {
  RequestCheckInController(this._ref)
    : super(const RequestCheckInState(isSending: false, lastMessage: null));

  final Ref _ref;

  Future<void> send() async {
    if (state.isSending) {
      return;
    }

    final session = _ref.read(appSessionProvider);
    final currentUser = session.currentUser;
    final currentPair = session.currentPair;
    if (currentUser == null || currentPair == null || currentPair.memberIds.length < 2) {
      state = const RequestCheckInState(
        isSending: false,
        lastMessage: 'Check-ins work best after you pair first.',
      );
      return;
    }

    final partnerUserId = currentPair.memberIds.firstWhere(
      (memberId) => memberId != currentUser.id,
      orElse: () => '',
    );
    if (partnerUserId.isEmpty) {
      state = const RequestCheckInState(
        isSending: false,
        lastMessage: 'Check-ins work best after you pair first.',
      );
      return;
    }

    state = const RequestCheckInState(isSending: true, lastMessage: null);
    try {
      final result = await _ref
          .read(sendRequestCheckInUseCaseProvider)
          .call(
            requesterUserId: currentUser.id,
            requesterName: currentUser.displayName,
            partnerUserId: partnerUserId,
          );
      _ref.invalidate(updatesProvider);
      _ref.invalidate(homeSnapshotProvider);

      state = RequestCheckInState(
        isSending: false,
        lastMessage: result.message,
      );
    } catch (_) {
      state = const RequestCheckInState(
        isSending: false,
        lastMessage: 'Something did not go as expected. We will try again automatically.',
      );
    }
  }

  void clearMessage() {
    state = RequestCheckInState(
      isSending: false,
      lastMessage: null,
    );
  }
}

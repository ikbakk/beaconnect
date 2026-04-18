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
    final partnerName = session.currentPair?.partnerDisplayName ?? 'Your partner';

    state = const RequestCheckInState(isSending: true, lastMessage: null);
    final result = await _ref
        .read(sendRequestCheckInUseCaseProvider)
        .call(partnerName: partnerName);
    _ref.invalidate(updatesProvider);
    _ref.invalidate(homeSnapshotProvider);

    state = RequestCheckInState(
      isSending: false,
      lastMessage: result.message,
    );
  }

  void clearMessage() {
    state = RequestCheckInState(
      isSending: false,
      lastMessage: null,
    );
  }
}

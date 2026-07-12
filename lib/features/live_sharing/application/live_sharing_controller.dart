import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../updates/domain/update_story.dart';
import '../domain/live_sharing_session.dart';

final liveSharingControllerProvider =
    StateNotifierProvider<LiveSharingController, LiveSharingState>(
      (ref) => LiveSharingController(ref),
    );

@immutable
class LiveSharingState {
  const LiveSharingState({
    required this.session,
    required this.isWorking,
    this.message,
  });

  final LiveSharingSession? session;
  final bool isWorking;
  final String? message;
}

class LiveSharingController extends StateNotifier<LiveSharingState> {
  LiveSharingController(this._ref)
    : super(const LiveSharingState(session: null, isWorking: false));

  final Ref _ref;

  Future<void> load() async {
    try {
      final session = await _ref.read(liveSharingRepositoryProvider).getCurrentSession();
      state = LiveSharingState(
        session: session,
        isWorking: false,
      );
    } catch (_) {
      state = LiveSharingState(
        session: state.session,
        isWorking: false,
        message: 'Live sharing is not ready just yet.',
      );
    }
  }

  Future<void> start({required int minutes, String? reason}) async {
    state = LiveSharingState(session: state.session, isWorking: true);
    try {
      final session = await _ref
          .read(liveSharingRepositoryProvider)
          .start(minutes: minutes, reason: reason);
      await _ref.read(addUpdateUseCaseProvider).call(
        UpdateStory(
          timeGroup: 'Just now',
          title: 'Sharing live',
          story: reason == null || reason.isEmpty
              ? 'You started sharing your current place for $minutes minutes.'
              : 'You started sharing your current place for $minutes minutes. $reason',
          place: 'Current place',
        ),
      );
      _ref.invalidate(homeSnapshotProvider);
      _ref.invalidate(updatesProvider);
      state = LiveSharingState(
        session: session,
        isWorking: false,
        message: 'Your current place is being shared for now.',
      );
    } catch (_) {
      state = LiveSharingState(
        session: state.session,
        isWorking: false,
        message: 'Live sharing could not start just yet.',
      );
    }
  }

  Future<void> pause() async {
    state = LiveSharingState(session: state.session, isWorking: true);
    try {
      final session = await _ref.read(liveSharingRepositoryProvider).pause();
      await _ref.read(addUpdateUseCaseProvider).call(
        const UpdateStory(
          timeGroup: 'Just now',
          title: 'Sharing paused',
          story: 'Live sharing is paused for now.',
          place: 'Current place',
        ),
      );
      _ref.invalidate(homeSnapshotProvider);
      _ref.invalidate(updatesProvider);
      state = LiveSharingState(
        session: session,
        isWorking: false,
        message: 'Sharing is paused for now.',
      );
    } catch (_) {
      state = LiveSharingState(
        session: state.session,
        isWorking: false,
        message: 'Live sharing could not be updated just yet.',
      );
    }
  }

  Future<void> resume() async {
    state = LiveSharingState(session: state.session, isWorking: true);
    try {
      final session = await _ref.read(liveSharingRepositoryProvider).resume();
      if (session != null) {
        await _ref.read(addUpdateUseCaseProvider).call(
          UpdateStory(
            timeGroup: 'Just now',
            title: 'Sharing live',
            story: session.reason == null || session.reason!.isEmpty
                ? 'Live sharing resumed quietly.'
                : 'Live sharing resumed. ${session.reason}',
            place: 'Current place',
          ),
        );
      }
      _ref.invalidate(homeSnapshotProvider);
      _ref.invalidate(updatesProvider);
      state = LiveSharingState(
        session: session,
        isWorking: false,
        message: session == null ? null : 'Sharing is live again.',
      );
    } catch (_) {
      state = LiveSharingState(
        session: state.session,
        isWorking: false,
        message: 'Live sharing could not be updated just yet.',
      );
    }
  }

  Future<void> end() async {
    state = LiveSharingState(session: state.session, isWorking: true);
    try {
      await _ref.read(liveSharingRepositoryProvider).end();
      await _ref.read(addUpdateUseCaseProvider).call(
        const UpdateStory(
          timeGroup: 'Just now',
          title: 'Sharing ended',
          story: 'Live sharing ended quietly.',
          place: 'Current place',
        ),
      );
      _ref.invalidate(homeSnapshotProvider);
      _ref.invalidate(updatesProvider);
      state = const LiveSharingState(
        session: null,
        isWorking: false,
        message: 'Sharing ended quietly.',
      );
    } catch (_) {
      state = LiveSharingState(
        session: state.session,
        isWorking: false,
        message: 'Live sharing could not be updated just yet.',
      );
    }
  }

  void clearMessage() {
    state = LiveSharingState(
      session: state.session,
      isWorking: state.isWorking,
    );
  }
}

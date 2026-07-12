import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/place_snapshot.dart';
import '../domain/place_snapshot_failure.dart';

final placeSnapshotControllerProvider =
    StateNotifierProvider<PlaceSnapshotController, PlaceSnapshotState>(
      (ref) => PlaceSnapshotController(ref),
    );

@immutable
class PlaceSnapshotState {
  const PlaceSnapshotState({
    required this.isCapturing,
    required this.lastMessage,
    required this.snapshot,
  });

  final bool isCapturing;
  final String? lastMessage;
  final PlaceSnapshot? snapshot;
}

class PlaceSnapshotController extends StateNotifier<PlaceSnapshotState> {
  PlaceSnapshotController(this._ref)
    : super(
        PlaceSnapshotState(
          isCapturing: false,
          lastMessage: null,
          snapshot: _ref.read(bootstrapStateProvider).latestPlaceSnapshot,
        ),
      );

  final Ref _ref;

  Future<void> capture() async {
    if (state.isCapturing) {
      return;
    }

    state = PlaceSnapshotState(
      isCapturing: true,
      lastMessage: null,
      snapshot: state.snapshot,
    );

    try {
      final snapshot = await _ref.read(capturePlaceSnapshotUseCaseProvider).call();
      _ref.invalidate(homeSnapshotProvider);

      state = PlaceSnapshotState(
        isCapturing: false,
        lastMessage: 'Showing your most recent update from ${snapshot.placeLabel}.',
        snapshot: snapshot,
      );
    } on PlaceSnapshotFailure catch (error) {
      state = PlaceSnapshotState(
        isCapturing: false,
        lastMessage: error.message,
        snapshot: state.snapshot,
      );
    } catch (_) {
      state = PlaceSnapshotState(
        isCapturing: false,
        lastMessage: 'Current place could not be updated just yet.',
        snapshot: state.snapshot,
      );
    }
  }

  void clearMessage() {
    state = PlaceSnapshotState(
      isCapturing: false,
      lastMessage: null,
      snapshot: state.snapshot,
    );
  }
}

import '../../updates/application/add_update_use_case.dart';
import '../../updates/domain/update_story.dart';
import '../domain/place_snapshot.dart';
import '../domain/place_snapshot_repository.dart';

class CapturePlaceSnapshotUseCase {
  const CapturePlaceSnapshotUseCase(
    this._repository,
    this._addUpdateUseCase,
  );

  final PlaceSnapshotRepository _repository;
  final AddUpdateUseCase _addUpdateUseCase;

  Future<PlaceSnapshot> call() async {
    final snapshot = await _repository.captureSnapshot();
    await _addUpdateUseCase(
      UpdateStory(
        timeGroup: 'Just now',
        title: 'Updated current place',
        story: 'Shared a new current place update.',
        place: snapshot.placeLabel,
      ),
    );
    return snapshot;
  }
}

import '../domain/place_snapshot.dart';
import '../domain/place_snapshot_repository.dart';

class CapturePlaceSnapshotUseCase {
  const CapturePlaceSnapshotUseCase(this._repository);

  final PlaceSnapshotRepository _repository;

  Future<PlaceSnapshot> call() {
    return _repository.captureSnapshot();
  }
}

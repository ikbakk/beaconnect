import '../domain/place_snapshot.dart';
import '../domain/place_snapshot_repository.dart';

class GetLatestPlaceSnapshotUseCase {
  const GetLatestPlaceSnapshotUseCase(this._repository);

  final PlaceSnapshotRepository _repository;

  Future<PlaceSnapshot?> call() {
    return _repository.getLatestSnapshot();
  }
}

import '../domain/home_repository.dart';
import '../domain/home_snapshot.dart';

class GetHomeSnapshotUseCase {
  const GetHomeSnapshotUseCase(this._repository);

  final HomeRepository _repository;

  Future<HomeSnapshot> call() {
    return _repository.getSnapshot();
  }
}

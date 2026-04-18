import '../domain/update_story.dart';
import '../domain/updates_repository.dart';

class GetUpdatesUseCase {
  const GetUpdatesUseCase(this._repository);

  final UpdatesRepository _repository;

  Future<List<UpdateStory>> call() {
    return _repository.getUpdates();
  }
}

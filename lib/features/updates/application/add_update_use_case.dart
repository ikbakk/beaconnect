import '../domain/update_story.dart';
import '../domain/updates_repository.dart';

class AddUpdateUseCase {
  const AddUpdateUseCase(this._repository);

  final UpdatesRepository _repository;

  Future<void> call(UpdateStory update) {
    return _repository.addUpdate(update);
  }
}

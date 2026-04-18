import 'update_story.dart';

abstract class UpdatesRepository {
  Future<List<UpdateStory>> getUpdates();
  Future<void> saveUpdates(List<UpdateStory> updates);
  Future<void> addUpdate(UpdateStory update);
}

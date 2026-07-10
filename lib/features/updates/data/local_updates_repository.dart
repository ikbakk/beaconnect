import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/update_story.dart';
import '../domain/updates_repository.dart';

class LocalUpdatesRepository implements UpdatesRepository {
  LocalUpdatesRepository(this._preferences);

  static const _updatesKey = 'updates.items';

  final SharedPreferences _preferences;

  @override
  Future<void> addUpdate(UpdateStory update) async {
    final updates = await getUpdates();
    final next = [update, ...updates];
    await saveUpdates(next);
  }

  @override
  Future<List<UpdateStory>> getUpdates() async {
    final raw = _preferences.getString(_updatesKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => UpdateStory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveUpdates(List<UpdateStory> updates) async {
    final encoded = jsonEncode(updates.map((item) => item.toJson()).toList());
    await _preferences.setString(_updatesKey, encoded);
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/place_snapshot.dart';
import '../domain/place_snapshot_repository.dart';

class LocalPlaceSnapshotRepository implements PlaceSnapshotRepository {
  LocalPlaceSnapshotRepository(this._preferences);

  static const _snapshotKey = 'place_snapshot.latest';

  final SharedPreferences _preferences;

  @override
  Future<PlaceSnapshot> captureSnapshot() async {
    final snapshot = PlaceSnapshot(
      placeLabel: 'Home',
      capturedAt: DateTime.now(),
    );
    await _preferences.setString(_snapshotKey, jsonEncode(snapshot.toJson()));
    return snapshot;
  }

  @override
  Future<PlaceSnapshot?> getLatestSnapshot() async {
    final raw = _preferences.getString(_snapshotKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return PlaceSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}

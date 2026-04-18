import 'place_snapshot.dart';

abstract class PlaceSnapshotRepository {
  Future<PlaceSnapshot?> getLatestSnapshot();
  Future<PlaceSnapshot> captureSnapshot();
}

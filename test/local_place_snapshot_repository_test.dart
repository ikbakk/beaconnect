import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/place_snapshot/data/local_place_snapshot_repository.dart';

void main() {
  test('captures and restores a local place snapshot', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalPlaceSnapshotRepository(preferences);

    final saved = await repository.captureSnapshot();
    final restored = await repository.getLatestSnapshot();

    expect(saved.placeLabel, 'Home');
    expect(restored?.placeLabel, 'Home');
  });
}

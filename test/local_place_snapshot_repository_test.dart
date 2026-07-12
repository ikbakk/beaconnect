import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/place_snapshot/data/local_place_snapshot_repository.dart';

void main() {
  test('captures and restores a device-backed place snapshot', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalPlaceSnapshotRepository(
      preferences,
      capturePlaceLabel: () async => 'Beacon Park',
      now: () => DateTime(2026, 7, 12, 9, 30),
    );

    final saved = await repository.captureSnapshot();
    final restored = await repository.getLatestSnapshot();

    expect(saved.placeLabel, 'Beacon Park');
    expect(restored?.placeLabel, 'Beacon Park');
  });
}

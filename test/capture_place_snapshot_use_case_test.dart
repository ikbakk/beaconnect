import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/place_snapshot/application/capture_place_snapshot_use_case.dart';
import 'package:beaconnect/features/place_snapshot/data/local_place_snapshot_repository.dart';
import 'package:beaconnect/features/updates/application/add_update_use_case.dart';
import 'package:beaconnect/features/updates/data/local_updates_repository.dart';

void main() {
  test('captures a place snapshot and adds a recent update', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final useCase = CapturePlaceSnapshotUseCase(
      LocalPlaceSnapshotRepository(preferences),
      AddUpdateUseCase(LocalUpdatesRepository(preferences)),
    );

    final snapshot = await useCase();
    final updates = await LocalUpdatesRepository(preferences).getUpdates();

    expect(snapshot.placeLabel, 'Home');
    expect(updates.first.title, 'Updated current place');
    expect(updates.first.place, 'Home');
  });
}

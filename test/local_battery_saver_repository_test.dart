import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/battery_saver/data/local_battery_saver_repository.dart';

void main() {
  test('stores battery saver preference locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalBatterySaverRepository(preferences);

    await repository.setEnabled(true);
    final enabled = await repository.isEnabled();

    expect(enabled, true);
  });
}

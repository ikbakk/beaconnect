import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/my_beacon/data/local_my_beacon_repository.dart';
import 'package:beaconnect/features/my_beacon/domain/my_beacon_preferences.dart';

void main() {
  test('stores my beacon preferences locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalMyBeaconRepository(preferences);

    await repository.savePreferences(
      const MyBeaconPreferences(
        pairSymbol: '♥',
        checkInMessage: 'sent love to {partner}.',
      ),
    );
    final restored = await repository.getPreferences();

    expect(restored.pairSymbol, '♥');
    expect(restored.checkInMessage, 'sent love to {partner}.');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/auth/domain/app_user.dart';
import 'package:beaconnect/features/pairing/data/local_pairing_repository.dart';

void main() {
  test('persists an approved pair locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalPairingRepository(preferences);

    await repository.approvePairing(
      currentUser: const AppUser(id: 'user-1', displayName: 'Iqbal'),
    );
    final restored = await repository.getCurrentPair();

    expect(restored?.status, 'active');
    expect(restored?.partnerDisplayName, 'Sarah');
  });
}

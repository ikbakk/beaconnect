import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/auth/domain/app_user.dart';
import 'package:beaconnect/features/pairing/data/local_pairing_repository.dart';
import 'package:beaconnect/features/pairing/domain/pairing_failure.dart';

void main() {
  const currentUser = AppUser(id: 'user-1', displayName: 'Iqbal');

  test('creates a pending invite for the current user', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalPairingRepository(preferences);

    final pair = await repository.createInviteCode(currentUser: currentUser);
    final restored = await repository.getCurrentPair();

    expect(pair.status, 'pending');
    expect(pair.inviteCode, 'BEACON');
    expect(restored?.status, 'pending');
  });

  test('does not allow using your own invite code', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalPairingRepository(preferences);

    final pair = await repository.createInviteCode(currentUser: currentUser);

    await expectLater(
      repository.approvePairing(
        currentUser: currentUser,
        inviteCode: pair.inviteCode,
      ),
      throwsA(
        isA<PairingFailure>().having(
          (error) => error.message,
          'message',
          'That is your code. Share it with your partner instead.',
        ),
      ),
    );
  });

  test('persists an approved pair locally for a partner code', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalPairingRepository(preferences);

    await repository.createInviteCode(currentUser: currentUser);
    await repository.approvePairing(
      currentUser: currentUser,
      inviteCode: '482915',
    );
    final restored = await repository.getCurrentPair();

    expect(restored?.status, 'active');
    expect(restored?.inviteCode, '482915');
    expect(restored?.partnerDisplayName, 'Sarah');
  });
}

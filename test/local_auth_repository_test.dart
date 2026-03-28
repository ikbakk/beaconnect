import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/auth/data/local_auth_repository.dart';

void main() {
  test('persists the signed-in user locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(preferences);

    await repository.signInWithGoogle();
    final restored = await repository.getCurrentUser();

    expect(restored?.displayName, 'Iqbal');
  });
}

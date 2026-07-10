import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/features/auth/data/local_auth_repository.dart';
import 'package:beaconnect/features/auth/domain/auth_failure.dart';

void main() {
  test('persists a signed-up user locally', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(preferences);

    await repository.signUpWithEmail(
      email: 'iqbal@example.com',
      password: 'password123',
    );
    final restored = await repository.getCurrentUser();

    expect(restored?.displayName, 'Iqbal');
  });

  test('sign-in asks for sign-up when no account exists yet', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = LocalAuthRepository(preferences);

    await expectLater(
      repository.signInWithEmail(
        email: 'iqbal@example.com',
        password: 'password123',
      ),
      throwsA(
        isA<AuthFailure>().having(
          (error) => error.message,
          'message',
          'We could not find an account with that email yet. Try signing up instead.',
        ),
      ),
    );
  });
}

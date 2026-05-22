import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/app/app.dart';
import 'package:beaconnect/app/bootstrap_state.dart';
import 'package:beaconnect/app/providers.dart';
import 'package:beaconnect/app/router.dart';
import 'package:beaconnect/features/auth/domain/app_user.dart';
import 'package:beaconnect/features/pairing/domain/pair_record.dart';

void main() {
  testWidgets('shows widget preview with one action', (tester) async {
    SharedPreferences.setMockInitialValues({
      'permissions.location_enabled': true,
      'permissions.notifications_enabled': true,
    });
    appRouter.go('/widget');
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          bootstrapStateProvider.overrideWithValue(
            const BootstrapState(
              currentUser: AppUser(id: 'user-1', displayName: 'Iqbal'),
              currentPair: PairRecord(
                id: 'pair-1',
                memberIds: ['user-1', 'user-2'],
                status: 'active',
                inviteCode: 'BEACON',
                partnerDisplayName: 'Sarah',
                expiresInMinutes: 5,
              ),
              hasCompletedOnboarding: true,
              latestPlaceSnapshot: null,
            ),
          ),
        ],
        child: const BeaconnectApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Widget preview'), findsOneWidget);
    expect(find.text("I'm Okay"), findsOneWidget);
  });
}

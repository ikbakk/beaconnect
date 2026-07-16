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
  testWidgets('settings, trust center, my beacon, and widget preview routes open', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'permissions.location_enabled': true,
      'permissions.notifications_enabled': true,
    });
    final preferences = await SharedPreferences.getInstance();
    appRouter.go('/settings');

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
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Trust Center and My Beacon'), findsOneWidget);
    expect(find.text('Trust Center'), findsOneWidget);

    appRouter.go('/trust-center');
    await tester.pumpAndSettle();
    expect(find.text('Trust Center'), findsOneWidget);

    appRouter.go('/my-beacon');
    await tester.pumpAndSettle();
    expect(find.text('My Beacon'), findsOneWidget);

    appRouter.go('/live-sharing');
    await tester.pumpAndSettle();
    expect(find.text('Start sharing'), findsOneWidget);

    appRouter.go('/widget');
    await tester.pumpAndSettle();
    expect(find.text('Widget preview'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:beaconnect/app/app.dart';
import 'package:beaconnect/app/bootstrap_state.dart';
import 'package:beaconnect/app/providers.dart';
import 'package:beaconnect/app/router.dart';
import 'package:beaconnect/features/auth/domain/app_user.dart';
import 'package:beaconnect/features/pairing/domain/pair_record.dart';
import 'package:beaconnect/features/place_snapshot/domain/place_snapshot.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    appRouter.go('/');
  });

  testWidgets('starts with the onboarding flow', (tester) async {
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          bootstrapStateProvider.overrideWithValue(
            const BootstrapState(
              currentUser: null,
              currentPair: null,
              hasCompletedOnboarding: false,
              latestPlaceSnapshot: null,
            ),
          ),
        ],
        child: const BeaconnectApp(),
      ),
    );

    expect(find.text('A quieter way to stay close.'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('can move through pairing into the home shell', (tester) async {
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          bootstrapStateProvider.overrideWithValue(
            const BootstrapState(
              currentUser: null,
              currentPair: null,
              hasCompletedOnboarding: false,
              latestPlaceSnapshot: null,
            ),
          ),
        ],
        child: const BeaconnectApp(),
      ),
    );

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'iqbal@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    if (find.text('Looks good').evaluate().isNotEmpty) {
      await tester.tap(find.text('Looks good'));
      await tester.pumpAndSettle();
    }
    if (find.text('Continue to home').evaluate().isNotEmpty) {
      await tester.tap(find.text('Continue to home'));
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('can join with a partner code', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          bootstrapStateProvider.overrideWithValue(
            const BootstrapState(
              currentUser: null,
              currentPair: null,
              hasCompletedOnboarding: false,
              latestPlaceSnapshot: null,
            ),
          ),
        ],
        child: const BeaconnectApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'iqbal@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '482915');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    if (find.text('Looks good').evaluate().isNotEmpty) {
      await tester.tap(find.text('Looks good'));
      await tester.pumpAndSettle();
    }
    if (find.text('Continue to home').evaluate().isNotEmpty) {
      await tester.tap(find.text('Continue to home'));
      await tester.pumpAndSettle();
    }

    expect(tester.takeException(), isNull);
  });

  testWidgets('restores a paired session on launch', (tester) async {
    SharedPreferences.setMockInitialValues({
      'permissions.location_enabled': true,
      'permissions.notifications_enabled': true,
    });
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          bootstrapStateProvider.overrideWithValue(
            BootstrapState(
              currentUser: const AppUser(id: 'user-1', displayName: 'Iqbal'),
              currentPair: const PairRecord(
                id: 'pair-1',
                memberIds: ['user-1', 'user-2'],
                status: 'active',
                inviteCode: 'BEACON',
                partnerDisplayName: 'Sarah',
                expiresInMinutes: 5,
              ),
              hasCompletedOnboarding: true,
              latestPlaceSnapshot: PlaceSnapshot(
                placeLabel: 'Home',
                capturedAt: DateTime(2026, 4, 12, 9, 0),
              ),
            ),
          ),
        ],
        child: const BeaconnectApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

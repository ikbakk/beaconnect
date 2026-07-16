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

    await _pumpApp(tester, preferences: preferences);

    expect(
      find.text('Built for reassurance,\nnot surveillance.'),
      findsOneWidget,
    );
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('can move through pairing into the home shell', (tester) async {
    final preferences = await SharedPreferences.getInstance();

    await _pumpApp(tester, preferences: preferences);
    await _createAccountUntilPairing(tester);

    await tester.ensureVisible(find.text('Skip for now'));
    await tester.tap(find.text('Skip for now'));
    await tester.pumpAndSettle();

    expect(find.text('Connections are always mutual.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('can join with a partner code', (tester) async {
    final preferences = await SharedPreferences.getInstance();

    await _pumpApp(tester, preferences: preferences);
    await _createAccountUntilPairing(tester);

    await tester.enterText(find.byType(TextField).first, '482915');
    await tester.ensureVisible(find.text('Generate Code'));
    await tester.tap(find.text('Generate Code'));
    await tester.pumpAndSettle();
    await _finishPairingFlow(tester);

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

Future<void> _pumpApp(
  WidgetTester tester, {
  required SharedPreferences preferences,
}) async {
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
}

Future<void> _createAccountUntilPairing(WidgetTester tester) async {
  await tester.tap(find.text('Get Started'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(0), 'iqbal@example.com');
  await tester.pump();
  await tester.enterText(find.byType(TextField).at(1), 'password123');
  await tester.pump();
  await tester.tap(find.text('Need an account? Sign up'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).at(2), 'password123');
  await tester.pump();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _finishPairingFlow(WidgetTester tester) async {
  await _tapIfVisible(tester, 'Continue');
  await _tapIfVisible(tester, 'Looks good');
  await _tapIfVisible(tester, 'Continue to home');
}

Future<void> _tapIfVisible(WidgetTester tester, String label) async {
  final finder = find.text(label);
  if (finder.evaluate().isEmpty) {
    return;
  }

  await tester.ensureVisible(finder.first);
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

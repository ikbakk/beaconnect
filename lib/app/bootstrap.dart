import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/app_config.dart';
import '../core/config/app_data_source.dart';
import '../features/auth/data/firebase_auth_repository.dart';
import '../features/auth/data/local_auth_repository.dart';
import '../features/pairing/data/firebase_pairing_repository.dart';
import '../features/pairing/data/local_pairing_repository.dart';
import '../features/place_snapshot/data/local_place_snapshot_repository.dart';
import '../firebase_options.dart';
import 'app.dart';
import 'bootstrap_state.dart';
import 'providers.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  const appConfig = AppConfig(dataSource: AppDataSource.firebase);

  if (appConfig.dataSource == AppDataSource.firebase) {
    try {
      Firebase.app();
    } catch (_) {
      if (Platform.isAndroid) {
        await Firebase.initializeApp();
      } else {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    }

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  final authRepository = switch (appConfig.dataSource) {
    AppDataSource.local => LocalAuthRepository(preferences),
    AppDataSource.firebase => FirebaseAuthRepository(),
  };
  final currentUser = await authRepository.getCurrentUser();

  final pairingRepository = switch (appConfig.dataSource) {
    AppDataSource.local => LocalPairingRepository(preferences),
    AppDataSource.firebase => FirebasePairingRepository(
      currentUserId: currentUser?.id,
    ),
  };
  final currentPair = await pairingRepository.getCurrentPair();
  final latestPlaceSnapshot = await LocalPlaceSnapshotRepository(
    preferences,
  ).getLatestSnapshot();

  final hasCompletedOnboarding =
      preferences.getBool(onboardingCompletePreferenceKey) ??
      (currentPair?.status == 'active');

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        appConfigProvider.overrideWithValue(appConfig),
        bootstrapStateProvider.overrideWithValue(
          BootstrapState(
            currentUser: currentUser,
            currentPair: currentPair,
            hasCompletedOnboarding: hasCompletedOnboarding,
            latestPlaceSnapshot: latestPlaceSnapshot,
          ),
        ),
      ],
      child: const BeaconnectApp(),
    ),
  );
}

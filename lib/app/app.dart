import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'router.dart';
import 'theme.dart';

class BeaconnectApp extends ConsumerWidget {
  const BeaconnectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(widgetUpdateProvider);

    final platformDispatcher = View.of(context).platformDispatcher;
    final reducedMotion =
        platformDispatcher.accessibilityFeatures.accessibleNavigation ||
        platformDispatcher.accessibilityFeatures.reduceMotion;

    return MaterialApp.router(
      title: 'Beaconnect',
      debugShowCheckedModeBanner: false,
      theme: BeaconnectTheme.light,
      routerConfig: appRouter,
      builder: (context, child) {
        if (reducedMotion) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          );
        }

        return child!;
      },
    );
  }
}

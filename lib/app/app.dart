import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class BeaconnectApp extends StatelessWidget {
  const BeaconnectApp({super.key});

  @override
  Widget build(BuildContext context) {
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

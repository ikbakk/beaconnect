import 'package:flutter/material.dart';

import 'router.dart';
import 'theme.dart';

class BeaconnectApp extends StatelessWidget {
  const BeaconnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Beaconnect',
      debugShowCheckedModeBanner: false,
      theme: BeaconnectTheme.light,
      routerConfig: appRouter,
    );
  }
}

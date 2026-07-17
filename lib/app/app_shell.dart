import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design/colors/bcg_colors.dart';
import '../design/components/bcg_bottom_nav.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import 'providers.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(appSessionProvider).hasPartner) {
      return const OnboardingScreen();
    }

    final path = GoRouterState.of(context).uri.path;

    return PopScope(
      canPop: _isHomeRoot(path),
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;

        if (!_isAtCurrentBranchRoot(path)) {
          context.pop();
          return;
        }

        if (navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: BcgColors.surface,
        body: navigationShell,
        bottomNavigationBar: BcgBottomNav(
          items: const [
            BcgNavItem(
              label: 'Home',
              route: '/home',
              icon: Icon(
                Icons.home_outlined,
                size: 24,
                color: BcgColors.fgMuted,
              ),
              activeIcon: Icon(
                Icons.home_rounded,
                size: 24,
                color: BcgColors.primary,
              ),
            ),
            BcgNavItem(
              label: 'Updates',
              route: '/updates',
              icon: Icon(
                Icons.notifications_outlined,
                size: 24,
                color: BcgColors.fgMuted,
              ),
              activeIcon: Icon(
                Icons.notifications_rounded,
                size: 24,
                color: BcgColors.primary,
              ),
            ),
            BcgNavItem(
              label: 'Settings',
              route: '/settings',
              icon: Icon(
                Icons.settings_outlined,
                size: 24,
                color: BcgColors.fgMuted,
              ),
              activeIcon: Icon(
                Icons.settings_rounded,
                size: 24,
                color: BcgColors.primary,
              ),
            ),
          ],
          currentRoute: path,
          onTap: (route) {
            final targetIndex = _indexForRoute(route);
            if (targetIndex == null) return;
            navigationShell.goBranch(
              targetIndex,
              initialLocation: targetIndex == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }

  bool _isHomeRoot(String path) => path == '/home';

  bool _isAtCurrentBranchRoot(String path) {
    return switch (navigationShell.currentIndex) {
      0 => path == '/home',
      1 => path == '/updates',
      2 => path == '/settings',
      _ => false,
    };
  }

  int? _indexForRoute(String route) {
    if (route.startsWith('/home')) return 0;
    if (route.startsWith('/updates')) return 1;
    if (route.startsWith('/settings')) return 2;
    return null;
  }
}

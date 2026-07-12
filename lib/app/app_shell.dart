import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../design/colors/bcg_colors.dart';
import '../design/spacing/bcg_spacing.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
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
        bottomNavigationBar: _PrototypeBottomTabs(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
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
}

class _PrototypeBottomTabs extends StatelessWidget {
  const _PrototypeBottomTabs({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: BcgColors.surfaceOverlay,
        border: Border(
          top: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: BcgSpacing.navH,
          child: Row(
            children: [
              _TabButton(
                label: 'Home',
                icon: Icons.home_rounded,
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _TabButton(
                label: 'Updates',
                icon: Icons.notifications_outlined,
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _TabButton(
                label: 'Settings',
                icon: Icons.settings_outlined,
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              left: 12,
              right: 12,
              top: 6,
              bottom: 6,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  color: isActive
                      ? BcgColors.primary.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isActive ? BcgColors.primary : BcgColors.fgMuted,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? BcgColors.primary : BcgColors.fgMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

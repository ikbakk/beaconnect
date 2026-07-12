import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../typography/bcg_typography.dart';

/// Navigation item for bottom nav
class BcgNavItem {
  const BcgNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });

  final String label;
  final Widget icon;
  final Widget activeIcon;
  final String route;
}

/// Pill-style bottom navigation bar
class BcgBottomNav extends StatelessWidget {
  const BcgBottomNav({
    super.key,
    required this.items,
    required this.currentRoute,
    required this.onTap,
  });

  final List<BcgNavItem> items;
  final String currentRoute;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BcgSpacing.navH,
      decoration: BoxDecoration(
        color: BcgColors.surfaceOverlay,
        border: const Border(
          top: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final isActive = _isActiveRoute(item.route);
            return Expanded(
              child: _BcgNavButton(
                item: item,
                isActive: isActive,
                onTap: () => onTap(item.route),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  bool _isActiveRoute(String route) {
    // Handle exact match and nested routes
    if (currentRoute == route) return true;
    if (route != '/' && currentRoute.startsWith(route)) return true;
    return false;
  }
}

class _BcgNavButton extends StatefulWidget {
  const _BcgNavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final BcgNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_BcgNavButton> createState() => _BcgNavButtonState();
}

class _BcgNavButtonState extends State<_BcgNavButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pill background animation
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            left: _isPressed || widget.isActive ? 12 : 12,
            right: _isPressed || widget.isActive ? 12 : 12,
            top: 6,
            bottom: 6,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: widget.isActive
                    ? BcgColors.primary.withOpacity(0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
          // Content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 120),
                child: widget.isActive
                    ? SizedBox(
                        key: const ValueKey('active'),
                        width: 24,
                        height: 24,
                        child: widget.item.activeIcon,
                      )
                    : SizedBox(
                        key: const ValueKey('inactive'),
                        width: 24,
                        height: 24,
                        child: widget.item.icon,
                      ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 120),
                style: BcgTypography.navLabel.copyWith(
                  color: widget.isActive
                      ? BcgColors.primary
                      : BcgColors.fgMuted,
                  fontWeight:
                      widget.isActive ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(widget.item.label),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

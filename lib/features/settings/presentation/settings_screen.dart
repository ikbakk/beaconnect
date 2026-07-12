import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/spacing/bcg_radius.dart';

/// Settings screen - matches design/prototype/beaconnect-app.html
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(
                BcgSpacing.s5,
                BcgSpacing.s5,
                BcgSpacing.s5,
                BcgSpacing.s4,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: BcgColors.outline, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.03,
                      color: BcgColors.fg,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Trust Center and My Beacon',
                    style: TextStyle(
                      fontSize: 14,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Relationship section
                  _SectionHeader(title: 'Relationship'),
                  _SettingsRow(
                    icon: Icons.star_outline,
                    iconColor: BcgColors.primary,
                    iconBg: BcgColors.primary,
                    label: 'Trust Center',
                    subtitle: 'Sharing, privacy, and how Beaconnect works',
                    onTap: () => context.go('/settings/trust-center'),
                  ),

                  // Personal section
                  _SectionHeader(title: 'Personal'),
                  _SettingsRow(
                    icon: Icons.blur_circular_outlined,
                    iconColor: BcgColors.success,
                    iconBg: BcgColors.successBg,
                    label: 'My Beacon',
                    subtitle: 'Personalize your experience',
                    onTap: () => context.go('/settings/my-beacon'),
                  ),

                  // About section
                  _SectionHeader(title: 'About'),
                  _SettingsRow(
                    icon: Icons.info_outline,
                    label: 'About Beaconnect',
                    subtitle: 'Version 1.0.0',
                    onTap: () {},
                  ),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(BcgSpacing.s5),
                    child: Center(
                      child: Text(
                        'Built for reassurance, not surveillance.',
                        style: TextStyle(
                          fontSize: 12,
                          color: BcgColors.fgMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BcgSpacing.s5,
        BcgSpacing.s3 + 4,
        BcgSpacing.s5,
        BcgSpacing.s2,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: BcgColors.fgMuted,
          letterSpacing: 0.08,
        ),
      ),
    );
  }
}

class _SettingsRow extends StatefulWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.iconColor,
    this.iconBg,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? iconBg;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = widget.iconColor ?? BcgColors.fg;
    final iconBg = widget.iconBg ?? BcgColors.surfaceVariant;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(BcgSpacing.s4),
          margin: const EdgeInsets.symmetric(horizontal: BcgSpacing.s2),
          decoration: BoxDecoration(
            color: _isHovered ? BcgColors.surfaceVariant : Colors.transparent,
            borderRadius: BcgRadius.borderSm,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BcgRadius.borderSm,
                ),
                child: Center(
                  child: Icon(widget.icon, size: 18, color: iconColor),
                ),
              ),

              const SizedBox(width: BcgSpacing.s3),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: BcgColors.fg,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        widget.subtitle!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: BcgColors.fgMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right,
                size: 16,
                color: BcgColors.outlineStrong,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentRoute,
    required this.onHome,
    required this.onUpdates,
    required this.onSettings,
  });

  final String currentRoute;
  final VoidCallback onHome;
  final VoidCallback onUpdates;
  final VoidCallback onSettings;

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
      child: Row(
        children: [
          _NavButton(
            label: 'Home',
            icon: Icons.home_rounded,
            isActive: currentRoute == '/',
            onTap: onHome,
          ),
          _NavButton(
            label: 'Updates',
            icon: Icons.notifications_outlined,
            isActive: currentRoute == '/updates',
            onTap: onUpdates,
          ),
          _NavButton(
            label: 'Settings',
            icon: Icons.settings_outlined,
            isActive: currentRoute == '/settings',
            onTap: onSettings,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
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
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isActive)
              Positioned(
                left: 12,
                right: 12,
                top: 6,
                bottom: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: BcgColors.primary.withValues(alpha: 0.14),
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

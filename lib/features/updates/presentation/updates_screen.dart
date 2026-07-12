import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/spacing/bcg_radius.dart';
import '../domain/update_story.dart';

/// Updates screen - matches design/prototype/beaconnect-app.html
/// Shows timeline of meaningful updates with icons and timestamps
class UpdatesScreen extends ConsumerWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updates = ref.watch(updatesProvider);

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
                BcgSpacing.s3 + 8,
                BcgSpacing.s5,
                BcgSpacing.s3 + 8,
              ),
              decoration: const BoxDecoration(
                color: BcgColors.surface,
                border: Border(
                  bottom: BorderSide(color: BcgColors.outline, width: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Updates',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.02,
                      color: BcgColors.fg,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Meaningful moments since you last looked',
                    style: TextStyle(
                      fontSize: 13,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: updates.when(
                data: (items) {
                  if (items.isEmpty) {
                    return _EmptyState();
                  }

                  // Group items by timeGroup
                  final groups = _groupByTimeGroup(items);

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (final group in groups) ...[
                        // Group label
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            BcgSpacing.s5,
                            BcgSpacing.s3,
                            BcgSpacing.s5,
                            BcgSpacing.s2,
                          ),
                          child: Text(
                            group.label.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: BcgColors.fgMuted,
                              letterSpacing: 0.08,
                            ),
                          ),
                        ),
                        // Items
                        for (final item in group.items)
                          _UpdateItem(
                            update: item,
                            onTap: () => _showUpdateDetail(context, item),
                          ),
                      ],
                      // End message
                      Padding(
                        padding: const EdgeInsets.all(BcgSpacing.s5),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "That's everything for today.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: BcgColors.fgMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'We\'ll keep you updated when something meaningful happens.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: BcgColors.fgMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => _ErrorState(
                  onRetry: () => ref.invalidate(updatesProvider),
                ),
                loading: () => const Center(
                  child: Text('Showing your most recent update…'),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  List<_TimeGroup> _groupByTimeGroup(List<UpdateStory> items) {
    final Map<String, List<UpdateStory>> grouped = {};
    for (final item in items) {
      grouped.putIfAbsent(item.timeGroup, () => []).add(item);
    }
    return grouped.entries
        .map((e) => _TimeGroup(label: e.key, items: e.value))
        .toList();
  }

  void _showUpdateDetail(BuildContext context, UpdateStory item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BcgColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _UpdateDetailSheet(item: item),
    );
  }
}

class _TimeGroup {
  const _TimeGroup({required this.label, required this.items});
  final String label;
  final List<UpdateStory> items;
}

class _UpdateItem extends StatefulWidget {
  const _UpdateItem({required this.update, required this.onTap});

  final UpdateStory update;
  final VoidCallback onTap;

  @override
  State<_UpdateItem> createState() => _UpdateItemState();
}

class _UpdateItemState extends State<_UpdateItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: BcgSpacing.s2),
          padding: const EdgeInsets.all(BcgSpacing.s4),
          decoration: BoxDecoration(
            color: _isHovered ? BcgColors.surfaceVariant : Colors.transparent,
            borderRadius: BcgRadius.borderSm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _getIconBackground(widget.update.type),
                  borderRadius: BcgRadius.borderSm,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: _getIconColor(widget.update.type),
                      size: 18,
                    ),
                    child: _getIcon(widget.update.type),
                  ),
                ),
              ),

              const SizedBox(width: BcgSpacing.s3),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.update.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BcgColors.fg,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.update.story,
                      style: const TextStyle(
                        fontSize: 13,
                        color: BcgColors.fgMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Time and arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.update.timeLabel,
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 11,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 120),
                    opacity: _isHovered ? 1.0 : 0.0,
                    child: const Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getIcon(String type) {
    switch (type) {
      case 'checkin':
        return const Icon(Icons.check_circle_outline);
      case 'arrival':
        return const Icon(Icons.home_outlined);
      case 'departure':
        return const Icon(Icons.logout);
      case 'live':
        return const Icon(Icons.radar);
      case 'reaction':
        return const Icon(Icons.favorite_outline);
      default:
        return const Icon(Icons.notifications_outlined);
    }
  }

  Color _getIconBackground(String type) {
    switch (type) {
      case 'checkin':
        return BcgColors.successBg;
      case 'reaction':
        return BcgColors.cautionBg;
      case 'live':
        return BcgColors.infoBg;
      default:
        return BcgColors.surfaceVariant;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'checkin':
        return BcgColors.success;
      case 'reaction':
        return BcgColors.caution;
      case 'live':
        return BcgColors.info;
      default:
        return BcgColors.fgMuted;
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BcgSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: BcgColors.surfaceVariant,
                borderRadius: BcgRadius.borderLg,
              ),
              child: const Center(
                child: Icon(
                  Icons.inbox_outlined,
                  size: 28,
                  color: BcgColors.fgMuted,
                ),
              ),
            ),
            const SizedBox(height: BcgSpacing.s4),
            Text(
              'No new updates yet.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BcgColors.fg,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We\'ll keep you updated when something meaningful happens.',
              style: TextStyle(
                fontSize: 13,
                color: BcgColors.fgMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BcgSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Something did not go as expected.',
              style: TextStyle(
                fontSize: 16,
                color: BcgColors.fg,
              ),
            ),
            const SizedBox(height: BcgSpacing.s4),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdateDetailSheet extends StatelessWidget {
  const _UpdateDetailSheet({required this.item});

  final UpdateStory item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          BcgSpacing.s5,
          BcgSpacing.s3,
          BcgSpacing.s5,
          BcgSpacing.s8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: BcgColors.outlineStrong,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: BcgSpacing.s4),

            // Title
            Text(
              item.title,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: BcgColors.fg,
              ),
            ),
            const SizedBox(height: BcgSpacing.s2),

            // Story
            Text(
              item.story,
              style: TextStyle(
                fontSize: 14,
                color: BcgColors.fgMuted,
              ),
            ),
            const SizedBox(height: BcgSpacing.s4),

            // Details
            Text(
              '${item.timeLabel} · ${item.place}',
              style: TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontSize: 12,
                color: BcgColors.fgMuted,
              ),
            ),
            const SizedBox(height: BcgSpacing.s5),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/spacing/bcg_radius.dart';
import '../../../design/components/bcg_interactive_map.dart';
import '../../check_in/application/check_in_controller.dart';
import '../../check_in/presentation/check_in_button.dart';
import '../../place_snapshot/application/place_snapshot_controller.dart';
import '../../request_check_in/presentation/request_check_in_button.dart';
import '../domain/home_state_variant.dart';
import 'widgets/home_update_card.dart';
import 'widgets/partner_card.dart';

/// Home screen - matches design/prototype/beaconnect-app.html
/// Shows partner card, I'm Okay button, quick actions, recent updates, map preview
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uri = GoRouter.of(context).routeInformationProvider.value.uri;
      if (uri.queryParameters['action'] == 'checkin') {
        _handleWidgetCheckIn();
      }
    });
  }

  void _handleWidgetCheckIn() {
    ref.read(checkInControllerProvider.notifier).sendCheckIn();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(checkInControllerProvider);
      if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message!)),
        );
        ref.read(checkInControllerProvider.notifier).reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(homeSnapshotProvider);
    final placeState = ref.watch(placeSnapshotControllerProvider);
    final placeController = ref.read(placeSnapshotControllerProvider.notifier);

    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        bottom: false,
        child: snapshot.when(
          data: (home) => Column(
            children: [
              // Scrollable content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // ── Partner Card ──────────────────────────────────────────
                    _Section(
                      padding: const EdgeInsets.fromLTRB(
                        BcgSpacing.s5,
                        BcgSpacing.s5,
                        BcgSpacing.s5,
                        0,
                      ),
                      child: PartnerCard(summary: home.partnerSummary),
                    ),

                    // ── I'm Okay CTA ──────────────────────────────────────────
                    _Section(
                      padding: const EdgeInsets.fromLTRB(
                        BcgSpacing.s5,
                        BcgSpacing.s5,
                        BcgSpacing.s5,
                        0,
                      ),
                      child: const CheckInButton(),
                    ),

                    // ── Quick Actions ───────────────────────────────────────
                    _Section(
                      padding: const EdgeInsets.fromLTRB(
                        BcgSpacing.s5,
                        BcgSpacing.s3,
                        BcgSpacing.s5,
                        0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RequestCheckInButton(
                              enabled: home.variant != HomeStateVariant.noPartner,
                            ),
                          ),
                          const SizedBox(width: BcgSpacing.s2 + 2),
                          Expanded(
                            child: _SecondaryButton(
                              label: 'Start Live',
                              icon: Icons.radar,
                              enabled: home.variant != HomeStateVariant.noPartner,
                              onPressed: () => context.go('/home/live-sharing'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Recent Updates ───────────────────────────────────────
                    _Section(
                      padding: const EdgeInsets.fromLTRB(
                        BcgSpacing.s5,
                        BcgSpacing.s5,
                        BcgSpacing.s5,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent updates',
                            style: TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: BcgColors.fgMuted,
                              letterSpacing: 0.08,
                            ),
                          ),
                          const SizedBox(height: BcgSpacing.s2),
                          if (home.updates.isEmpty)
                            _EmptyUpdates()
                          else
                            ...home.updates.map(
                              (update) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: BcgSpacing.s2),
                                child: HomeUpdateCard(update: update),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // ── Map Preview ─────────────────────────────────────────
                    _Section(
                      padding: const EdgeInsets.fromLTRB(
                        BcgSpacing.s5,
                        BcgSpacing.s4,
                        BcgSpacing.s5,
                        0,
                      ),
                      child: Column(
                        children: [
                          BcgInteractiveMapPreview(
                            label: home.placeSnapshot?.placeLabel ?? 'Update current place for map',
                            latitude: home.placeSnapshot?.latitude,
                            longitude: home.placeSnapshot?.longitude,
                            isUpdating: placeState.isCapturing,
                            onTap: () {
                              final label = Uri.encodeComponent(
                                home.placeSnapshot?.placeLabel ?? 'Current place',
                              );
                              final lat = home.placeSnapshot?.latitude;
                              final lng = home.placeSnapshot?.longitude;
                              final coords = lat == null || lng == null
                                  ? ''
                                  : '&lat=$lat&lng=$lng';
                              context.go('/home/map?label=$label$coords');
                            },
                          ),
                          const SizedBox(height: BcgSpacing.s2),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: placeState.isCapturing
                                  ? null
                                  : () async {
                                      await placeController.capture();
                                      final message = ref
                                          .read(placeSnapshotControllerProvider)
                                          .lastMessage;
                                      if (context.mounted && message != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(message)),
                                        );
                                      }
                                      placeController.clearMessage();
                                    },
                              child: Text(
                                placeState.isCapturing
                                    ? 'Updating…'
                                    : 'Update current place',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── View All Updates ─────────────────────────────────────
                    _Section(
                      padding: const EdgeInsets.fromLTRB(
                        BcgSpacing.s5,
                        BcgSpacing.s2,
                        BcgSpacing.s5,
                        BcgSpacing.s8,
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () => context.go('/updates'),
                          child: const Text('View all updates →'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
          error: (_, __) => _ErrorState(
            onRetry: () => ref.invalidate(homeSnapshotProvider),
          ),
          loading: () => const Center(
            child: Text('Showing your most recent update…'),
          ),
        ),
      ),
    );
  }
}

/// Helper wrapper for consistent section padding
class _Section extends StatelessWidget {
  const _Section({required this.padding, required this.child});

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

/// Empty updates placeholder
class _EmptyUpdates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s5),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
      ),
      child: Text(
        'No new updates yet.',
        style: TextStyle(
          fontSize: 14,
          color: BcgColors.fgMuted,
        ),
      ),
    );
  }
}

/// Error state
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
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
          FilledButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

/// Map preview card
class _MapPreview extends StatelessWidget {
  const _MapPreview({
    required this.label,
    required this.onTap,
    this.isUpdating = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: BcgColors.surfaceVariant,
          borderRadius: BcgRadius.borderMd,
          border: Border.all(color: BcgColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Placeholder map content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 32,
                    color: BcgColors.fgMuted,
                  ),
                  const SizedBox(height: BcgSpacing.s2),
                  Text(
                    isUpdating ? 'Updating current place…' : 'Tap to update current place',
                    style: TextStyle(
                      fontSize: 12,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Label
            Positioned(
              left: BcgSpacing.s3,
              bottom: BcgSpacing.s3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BcgSpacing.s3,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: BcgColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(BcgRadius.sm),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: BcgColors.fg,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Secondary button (outlined style)
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BcgColors.surfaceVariant,
      borderRadius: BcgRadius.borderMd,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BcgRadius.borderMd,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BcgSpacing.s4,
              vertical: BcgSpacing.s3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: BcgColors.fgMuted),
                const SizedBox(width: BcgSpacing.s2),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BcgColors.fg,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom navigation button
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
            // Pill background
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
            // Content
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

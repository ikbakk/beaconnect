import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/bcg_theme.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/components/bcg_buttons.dart';
import '../../../design/components/bcg_interactive_map.dart';
import '../../../design/spacing/bcg_radius.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/typography/bcg_typography.dart';
import '../../check_in/application/check_in_controller.dart';
import '../../check_in/presentation/check_in_button.dart';
import '../../live_sharing/application/live_sharing_controller.dart';
import '../../live_sharing/domain/live_sharing_session.dart';
import '../../place_snapshot/application/place_snapshot_controller.dart';
import '../../request_check_in/presentation/request_check_in_button.dart';
import '../domain/home_snapshot.dart';
import '../domain/home_state_variant.dart';
import 'widgets/home_update_card.dart';
import 'widgets/partner_card.dart';

/// Home screen — matches `design/prototype/beaconnect-app.html` and
/// `docs/02-interface/home-v1.md`.
///
/// The interaction is the prototype's signature: tapping **Start Live** toggles
/// live sharing in place. The map is promoted to a hero at the top via a 320ms
/// `AnimatedCrossFade`, the recent-updates module collapses, the partner card
/// transitions to the `live` state, and the button label flips to **Stop
/// Live**. The `/home/live-sharing` route is reachable from the live button
/// for duration and reason configuration.
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
      if (!mounted) return;
      final uri = GoRouter.of(context).routeInformationProvider.value.uri;
      if (uri.queryParameters['action'] == 'checkin') {
        _handleWidgetCheckIn();
      }
      // Pull the current live session + re-read the I'm Okay label in case
      // the user changed either while the home was off-screen.
      ref.read(liveSharingControllerProvider.notifier).load();
      ref.read(checkInControllerProvider.notifier).refreshIdleLabel();
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

  Future<void> _toggleLiveSharing() async {
    final controller = ref.read(liveSharingControllerProvider.notifier);
    final state = ref.read(liveSharingControllerProvider);
    final session = state.session;
    if (session == null) {
      await controller.start(minutes: 30);
    } else if (session.isPaused) {
      await controller.resume();
    } else {
      await controller.end();
    }
    if (!mounted) return;
    final message = ref.read(liveSharingControllerProvider).message;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      controller.clearMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(homeSnapshotProvider);
    final liveState = ref.watch(liveSharingControllerProvider);
    final placeState = ref.watch(placeSnapshotControllerProvider);
    final placeController = ref.read(placeSnapshotControllerProvider.notifier);

    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        bottom: false,
        child: snapshot.when(
          data: (home) {
            final isLive = liveState.session != null && !liveState.session!.isPaused;
            final isPaused = liveState.session?.isPaused ?? false;
            final liveLabel = isLive
                ? 'Stop Live'
                : isPaused
                    ? 'Resume'
                    : 'Start Live';
            return _HomeBody(
              home: home,
              isLive: isLive,
              isPaused: isPaused,
              liveLabel: liveLabel,
              liveSession: liveState.session,
              placeState: placeState,
              onToggleLive: home.variant == HomeStateVariant.noPartner
                  ? null
                  : _toggleLiveSharing,
              onCapturePlace: () async {
                final messenger = ScaffoldMessenger.of(context);
                await placeController.capture();
                if (!mounted) return;
                final message =
                    ref.read(placeSnapshotControllerProvider).lastMessage;
                if (message != null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
                placeController.clearMessage();
              },
              onOpenMap: () => _openMapDetail(home),
              onViewAllUpdates: () => context.go('/updates'),
            );
          },
          error: (_, _) => _ErrorState(
            onRetry: () => ref.invalidate(homeSnapshotProvider),
          ),
          loading: () => const _LoadingState(),
        ),
      ),
    );
  }

  void _openMapDetail(HomeSnapshot home) {
    final place = home.placeSnapshot;
    final label = Uri.encodeComponent(place?.placeLabel ?? 'Current place');
    final lat = place?.latitude;
    final lng = place?.longitude;
    final coords = lat == null || lng == null ? '' : '&lat=$lat&lng=$lng';
    context.go('/home/map?label=$label$coords');
  }
}

/// The scrollable home body. Lives in its own widget so the parent can keep
/// the data fetching tight while this lays out the calm visual rhythm.
class _HomeBody extends StatelessWidget {
  const _HomeBody({
    required this.home,
    required this.isLive,
    required this.isPaused,
    required this.liveLabel,
    required this.liveSession,
    required this.placeState,
    required this.onToggleLive,
    required this.onCapturePlace,
    required this.onOpenMap,
    required this.onViewAllUpdates,
  });

  final HomeSnapshot home;
  final bool isLive;
  final bool isPaused;
  final String liveLabel;
  final LiveSharingSession? liveSession;
  final PlaceSnapshotState placeState;
  final VoidCallback? onToggleLive;
  final VoidCallback onCapturePlace;
  final VoidCallback onOpenMap;
  final VoidCallback onViewAllUpdates;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              BcgSpacing.s5,
              BcgSpacing.s5,
              BcgSpacing.s5,
              0,
            ),
            child: PartnerCard(summary: home.partnerSummary),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              BcgSpacing.s5,
              BcgSpacing.s5,
              BcgSpacing.s5,
              0,
            ),
            child: const CheckInButton(),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
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
                  child: BcgButton(
                    label: liveLabel,
                    onPressed: onToggleLive,
                    variant: BcgButtonVariant.secondary,
                    icon: Icon(
                      isLive
                          ? Icons.stop_circle_outlined
                          : isPaused
                              ? Icons.play_circle_outline
                              : Icons.radar,
                      size: 18,
                      color: BcgColors.fgMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Map: secondary in idle, hero in live. 320ms crossfade per
        // home-v1.md "Live transition" (motion.slow = 320ms).
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              BcgSpacing.s5,
              BcgSpacing.s4,
              BcgSpacing.s5,
              0,
            ),
            child: AnimatedCrossFade(
              duration: BcgMotion.slow,
              firstCurve: BcgMotion.easeInOut,
              secondCurve: BcgMotion.easeInOut,
              sizeCurve: BcgMotion.easeInOut,
              crossFadeState: isLive
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: BcgInteractiveMapPreview(
                label: home.placeSnapshot?.placeLabel ??
                    'Tap to add your current place',
                latitude: home.placeSnapshot?.latitude,
                longitude: home.placeSnapshot?.longitude,
                isUpdating: placeState.isCapturing,
                onTap: onOpenMap,
              ),
              secondChild: _LiveHeroMap(
                label: home.placeSnapshot?.placeLabel ?? 'Sharing your area',
                liveDuration: _formatLiveDuration(liveSession),
                onTap: onOpenMap,
              ),
            ),
          ),
        ),
        // Recent updates — collapse when live so the hero owns the screen.
        SliverToBoxAdapter(
          child: AnimatedSize(
            duration: BcgMotion.mid,
            curve: BcgMotion.easeInOut,
            child: isLive
                ? const SizedBox(width: double.infinity, height: 0)
                : Padding(
                    padding: const EdgeInsets.fromLTRB(
                      BcgSpacing.s5,
                      BcgSpacing.s4,
                      BcgSpacing.s5,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionEyebrow(
                          title: 'RECENT',
                          trailing: TextButton(
                            onPressed: onViewAllUpdates,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 0),
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'View all updates →',
                              style: BcgTypography.buttonSmall.copyWith(
                                color: BcgColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: BcgSpacing.s2),
                        if (home.updates.isEmpty)
                          const _EmptyUpdates()
                        else
                          ...home.updates.map(
                            (update) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: BcgSpacing.s2,
                              ),
                              child: HomeUpdateCard(update: update),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              BcgSpacing.s5,
              BcgSpacing.s6,
              BcgSpacing.s5,
              BcgSpacing.s8,
            ),
            child: Center(
              child: TextButton(
                onPressed: isLive ? null : onCapturePlace,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BcgSpacing.s3,
                    vertical: BcgSpacing.s2,
                  ),
                ),
                child: Text(
                  placeState.isCapturing
                      ? 'Updating current place…'
                      : 'Update your current place',
                  style: BcgTypography.buttonSmall.copyWith(
                    color: placeState.isCapturing
                        ? BcgColors.fgMuted
                        : BcgColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Renders the "RECENT" eyebrow + a "View all updates →" link on one row.
class _SectionEyebrow extends StatelessWidget {
  const _SectionEyebrow({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: BcgTypography.monoSmall.copyWith(
            color: BcgColors.fgMuted,
            letterSpacing: 0.08,
          ),
        ),
        const Spacer(),
        ?trailing,
      ],
    );
  }
}

/// Calm approximation surface for the live hero map. Matches the
/// prototype's "approximate area" intent — not a real map.
class _LiveHeroMap extends StatefulWidget {
  const _LiveHeroMap({
    required this.label,
    required this.liveDuration,
    required this.onTap,
  });

  final String label;
  final String liveDuration;
  final VoidCallback onTap;

  @override
  State<_LiveHeroMap> createState() => _LiveHeroMapState();
}

class _LiveHeroMapState extends State<_LiveHeroMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    duration: const Duration(milliseconds: 1200),
    vsync: this,
  )..forward();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: BcgColors.surfaceVariant,
          borderRadius: BcgRadius.borderMd,
          border: Border.all(color: BcgColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Soft terrain hint — three concentric primary rings, then a
            // solid dot. One-time fade on mount.
            Positioned.fill(
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) {
                    final t = Curves.easeOut.transform(_pulse.value);
                    return SizedBox(
                      width: 160,
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _Ring(diameter: 160, opacity: 0.05 * t),
                          _Ring(diameter: 110, opacity: 0.10 * t),
                          _Ring(diameter: 64, opacity: 0.18 * t),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: BcgColors.primary
                                  .withValues(alpha: 0.95),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BcgColors.primaryFg,
                                width: 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // LIVE badge
            Positioned(
              right: BcgSpacing.s3 + 4,
              top: BcgSpacing.s3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: BcgColors.primary,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: BcgColors.primaryFg,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE · ${widget.liveDuration}',
                      style: BcgTypography.monoCaption.copyWith(
                        color: BcgColors.primaryFg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Place label
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
                  widget.label,
                  style: BcgTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
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

class _Ring extends StatelessWidget {
  const _Ring({required this.diameter, required this.opacity});

  final double diameter;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: BcgColors.primary.withValues(alpha: opacity.clamp(0.0, 1.0)),
          width: 1,
        ),
      ),
    );
  }
}

class _EmptyUpdates extends StatelessWidget {
  const _EmptyUpdates();

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
        style: BcgTypography.bodySmall.copyWith(color: BcgColors.fgMuted),
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
        padding: const EdgeInsets.all(BcgSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Something did not go as expected.',
              style: BcgTypography.headerTitle.copyWith(color: BcgColors.fg),
            ),
            const SizedBox(height: BcgSpacing.s3),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Try again',
                style: BcgTypography.buttonSmall.copyWith(
                  color: BcgColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(BcgSpacing.s6),
        child: Text(
          'Showing your most recent update.',
          style: BcgTypography.bodyMedium.copyWith(color: BcgColors.fgMuted),
        ),
      ),
    );
  }
}

String _formatLiveDuration(LiveSharingSession? session) {
  if (session == null) return '0m';
  final m = session.minutesRemaining;
  if (m <= 0) return '0m';
  if (m < 60) return '${m}m';
  final h = m ~/ 60;
  final r = m % 60;
  return r == 0 ? '${h}h' : '${h}h ${r}m';
}

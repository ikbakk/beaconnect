import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_radius.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../application/live_sharing_controller.dart';

/// Live sharing screen wired to LiveSharingController.
/// Keeps the prototype's calm card/action language while preserving core actions.
class LiveSharingScreen extends ConsumerStatefulWidget {
  const LiveSharingScreen({super.key});

  @override
  ConsumerState<LiveSharingScreen> createState() => _LiveSharingScreenState();
}

class _LiveSharingScreenState extends ConsumerState<LiveSharingScreen> {
  int _minutes = 30;
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(liveSharingControllerProvider.notifier).load(),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liveSharingControllerProvider);
    final controller = ref.read(liveSharingControllerProvider.notifier);
    final session = state.session;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = ref.read(liveSharingControllerProvider).message;
      if (!mounted || message == null) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      controller.clearMessage();
    });

    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _LiveHeader(onBack: () => context.pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(BcgSpacing.s5),
                children: [
                  if (session != null)
                    _ActiveSharingCard(
                      isPaused: session.isPaused,
                      reason: session.reason,
                      minutesRemaining: session.minutesRemaining,
                      isWorking: state.isWorking,
                      onPauseResume: session.isPaused
                          ? controller.resume
                          : controller.pause,
                      onEnd: controller.end,
                    )
                  else
                    _StartSharingCard(
                      minutes: _minutes,
                      reasonController: _reasonController,
                      isWorking: state.isWorking,
                      onMinutesChanged: (minutes) {
                        setState(() => _minutes = minutes);
                      },
                      onStart: () => controller.start(
                        minutes: _minutes,
                        reason: _reasonController.text.trim(),
                      ),
                    ),
                  const SizedBox(height: BcgSpacing.s5),
                  const _LiveTrustNote(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveHeader extends StatelessWidget {
  const _LiveHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        BcgSpacing.s5,
        BcgSpacing.s3 + 4,
        BcgSpacing.s5,
        BcgSpacing.s4,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BcgColors.outline, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back, size: 16, color: BcgColors.fgMuted),
                SizedBox(width: 4),
                Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 13,
                    color: BcgColors.fgMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: BcgSpacing.s2),
          const Text(
            'Live sharing',
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: BcgColors.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Share for a little while',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.03,
              color: BcgColors.fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StartSharingCard extends StatelessWidget {
  const _StartSharingCard({
    required this.minutes,
    required this.reasonController,
    required this.isWorking,
    required this.onMinutesChanged,
    required this.onStart,
  });

  final int minutes;
  final TextEditingController reasonController;
  final bool isWorking;
  final ValueChanged<int> onMinutesChanged;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s5),
      decoration: BoxDecoration(
        color: BcgColors.surface,
        borderRadius: BcgRadius.borderLg,
        border: Border.all(color: BcgColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose a duration',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),
          const SizedBox(height: BcgSpacing.s3),
          Wrap(
            spacing: BcgSpacing.s2,
            children: [15, 30, 60].map((value) {
              return _DurationChip(
                label: '${value}m',
                isSelected: minutes == value,
                onTap: () => onMinutesChanged(value),
              );
            }).toList(),
          ),
          const SizedBox(height: BcgSpacing.s5),
          TextField(
            controller: reasonController,
            decoration: _inputDecoration(
              label: 'Optional note',
              hint: 'Going home',
            ),
          ),
          const SizedBox(height: BcgSpacing.s5),
          _PrimaryActionButton(
            label: isWorking ? 'Starting…' : 'Start sharing',
            onPressed: isWorking ? null : onStart,
          ),
        ],
      ),
    );
  }
}

class _ActiveSharingCard extends StatelessWidget {
  const _ActiveSharingCard({
    required this.isPaused,
    required this.reason,
    required this.minutesRemaining,
    required this.isWorking,
    required this.onPauseResume,
    required this.onEnd,
  });

  final bool isPaused;
  final String? reason;
  final int minutesRemaining;
  final bool isWorking;
  final VoidCallback onPauseResume;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s5),
      decoration: BoxDecoration(
        color: BcgColors.surface,
        borderRadius: BcgRadius.borderLg,
        border: Border.all(color: BcgColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(label: isPaused ? 'Paused' : 'Live', isPaused: isPaused),
              const Spacer(),
              Text(
                isPaused ? 'Paused for now' : '$minutesRemaining min left',
                style: const TextStyle(
                  fontFamily: 'IBM Plex Mono',
                  fontSize: 12,
                  color: BcgColors.fgMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: BcgSpacing.s4),
          Text(
            isPaused ? 'Sharing is currently paused.' : 'Sharing live.',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),
          if (reason != null && reason!.isNotEmpty) ...[
            const SizedBox(height: BcgSpacing.s2),
            Text(
              reason!,
              style: const TextStyle(fontSize: 14, color: BcgColors.fgMuted),
            ),
          ],
          const SizedBox(height: BcgSpacing.s5),
          Row(
            children: [
              Expanded(
                child: _SecondaryActionButton(
                  label: isPaused ? 'Resume' : 'Pause',
                  onPressed: isWorking ? null : onPauseResume,
                ),
              ),
              const SizedBox(width: BcgSpacing.s3),
              Expanded(
                child: _PrimaryActionButton(
                  label: isWorking ? 'Updating…' : 'End',
                  onPressed: isWorking ? null : onEnd,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveTrustNote extends StatelessWidget {
  const _LiveTrustNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s4),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
        border: Border.all(color: BcgColors.outline),
      ),
      child: const Text(
        'Live sharing is temporary and can be stopped at any time. Beaconnect shows reassurance, not a running log.',
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: BcgColors.fgMuted,
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? BcgColors.primary : BcgColors.surfaceVariant,
          borderRadius: BcgRadius.borderMd,
          border: Border.all(
            color: isSelected ? BcgColors.primary : BcgColors.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? BcgColors.primaryFg : BcgColors.fg,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.isPaused});

  final String label;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final color = isPaused ? BcgColors.caution : BcgColors.critical;
    final bg = isPaused ? BcgColors.cautionBg : BcgColors.criticalBg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.45 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: BcgSpacing.s6,
            vertical: BcgSpacing.s5 - 2,
          ),
          decoration: BoxDecoration(
            color: BcgColors.primary,
            borderRadius: BcgRadius.borderLg,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: BcgColors.primaryFg,
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.45 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: BcgSpacing.s4,
            vertical: BcgSpacing.s3,
          ),
          decoration: BoxDecoration(
            color: BcgColors.surfaceVariant,
            borderRadius: BcgRadius.borderMd,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({required String label, String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: BcgColors.fgMuted),
    hintStyle: const TextStyle(color: BcgColors.fgMuted),
    filled: true,
    fillColor: BcgColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: BcgSpacing.s4,
      vertical: BcgSpacing.s3 + 2,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BcgRadius.borderMd,
      borderSide: const BorderSide(color: BcgColors.outline, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BcgRadius.borderMd,
      borderSide: const BorderSide(color: BcgColors.primary, width: 1.5),
    ),
  );
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

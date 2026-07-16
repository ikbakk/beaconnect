import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../../design/spacing/bcg_radius.dart';

/// Trust Center screen - matches design/prototype/beaconnect-app.html
class TrustCenterScreen extends ConsumerWidget {
  const TrustCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionProvider);
    final permissions = ref.watch(permissionStatusProvider);
    final batterySaver = ref.watch(batterySaverEnabledProvider);
    final partnerName = session.currentPair?.partnerDisplayName ?? 'your partner';

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
                BcgSpacing.s3 + 4,
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
                  // Back button
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.arrow_back, size: 16, color: BcgColors.fgMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Settings',
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
                  Text(
                    'Trust Center',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Mono',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: BcgColors.fgMuted,
                      letterSpacing: 0.08,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Can I trust Beaconnect?',
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
            ),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Our Connection
                  _TrustSection(
                    title: 'Our Connection',
                    description: session.hasPartner
                        ? 'You and $partnerName are connected through mutual sharing. Connections are always voluntary and can be ended at any time by either person.'
                        : 'Beaconnect starts with mutual consent. Invite your partner when both of you are ready.',
                    statusLabel: session.hasPartner
                        ? 'Connected with care'
                        : 'Not connected yet',
                    statusVariant: session.hasPartner
                        ? _TrustStatusVariant.ok
                        : _TrustStatusVariant.info,
                  ),

                  // Sharing
                  _TrustSection(
                    title: 'Sharing',
                    description: 'Beaconnect only shares what both people choose. Check-ins are intentional — one person presses a button and the other sees it. Live sharing is temporary and ends automatically.',
                    statusLabel: batterySaver.when(
                      data: (enabled) => enabled
                          ? 'Battery Saver Mode is on'
                          : 'Mutual sharing active',
                      error: (_, _) => 'We will check again automatically',
                      loading: () => 'Checking gently…',
                    ),
                    statusVariant: batterySaver.maybeWhen(
                      data: (enabled) => enabled
                          ? _TrustStatusVariant.warn
                          : _TrustStatusVariant.ok,
                      orElse: () => _TrustStatusVariant.info,
                    ),
                    actionLabel: 'Toggle battery saver →',
                    onAction: () async {
                      final enabled = await ref.read(batterySaverEnabledProvider.future);
                      await ref.read(toggleBatterySaverUseCaseProvider).call(!enabled);
                      ref.invalidate(batterySaverEnabledProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              !enabled
                                  ? 'Battery Saver Mode is on.'
                                  : 'Battery Saver Mode is off.',
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  // Privacy
                  _TrustSection(
                    title: 'Privacy',
                    description: 'Your updates are visible only to your partner — not to Beaconnect, not to anyone else. Detailed location is kept private and shared only when earned.',
                    statusLabel: 'Private by design',
                    statusVariant: _TrustStatusVariant.ok,
                  ),

                  // History
                  _TrustSection(
                    title: 'History',
                    description: 'Detailed updates are kept for 3 days. After that, they\'re summarized into a monthly overview. Both people can delete history — it requires both to agree.',
                    statusLabel: '3-day detail window',
                    statusVariant: _TrustStatusVariant.info,
                  ),

                  // Permissions
                  _TrustSection(
                    title: 'Permissions',
                    description: 'Beaconnect needs access to your location when you choose to share — not all the time, just when live sharing is on.',
                    statusLabel: permissions.when(
                      data: (value) => value.isReadyForSharing
                          ? 'Location sharing on'
                          : 'Sharing works best when enabled',
                      error: (_, _) => 'We will check again automatically',
                      loading: () => 'Checking gently…',
                    ),
                    statusVariant: permissions.maybeWhen(
                      data: (value) => value.isReadyForSharing
                          ? _TrustStatusVariant.ok
                          : _TrustStatusVariant.warn,
                      orElse: () => _TrustStatusVariant.info,
                    ),
                    actionLabel: 'Review status →',
                    onAction: () async {
                      final status = await ref
                          .read(enablePermissionEducationUseCaseProvider)
                          .call();
                      ref.invalidate(permissionStatusProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              status.isReadyForSharing
                                  ? 'Sharing is ready.'
                                  : 'Sharing works best when permission is enabled.',
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  // How Beaconnect Works
                  _TrustSection(
                    title: 'How Beaconnect Works',
                    description: '',
                    statusLabel: '',
                    handbookItems: const [
                      _HandbookItem(
                        question: 'Why is live sharing temporary?',
                        answer: 'Live sharing shows where you are while you\'re actively sharing — it ends automatically so neither person feels watched.',
                      ),
                      _HandbookItem(
                        question: 'Why not every movement is shown',
                        answer: 'Seeing every step creates anxiety for both people. Beaconnect shows meaningful moments, not a running log.',
                      ),
                      _HandbookItem(
                        question: 'Why consent matters',
                        answer: 'Beaconnect only works when both people agree. Either person can end the connection at any time.',
                      ),
                    ],
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

enum _TrustStatusVariant { ok, warn, info }

class _TrustSection extends StatelessWidget {
  const _TrustSection({
    required this.title,
    required this.description,
    required this.statusLabel,
    this.statusVariant = _TrustStatusVariant.ok,
    this.actionLabel,
    this.onAction,
    this.handbookItems,
  });

  final String title;
  final String description;
  final String statusLabel;
  final _TrustStatusVariant statusVariant;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<_HandbookItem>? handbookItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        BcgSpacing.s5,
        BcgSpacing.s4,
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
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),
          const SizedBox(height: 6),

          // Description
          if (description.isNotEmpty) ...[
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: BcgColors.fgMuted,
                height: 1.55,
              ),
            ),
            const SizedBox(height: BcgSpacing.s3),
          ],

          // Status badge
          if (statusLabel.isNotEmpty)
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: BcgColors.surfaceVariant,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: BcgColors.fgMuted,
                  ),
                ),
              ],
            ),
            ),

          // Action
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: BcgColors.primary,
                ),
              ),
            ),
          ],

          // Handbook items
          if (handbookItems != null && handbookItems!.isNotEmpty) ...[
            const SizedBox(height: BcgSpacing.s4),
            ...handbookItems!.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: BcgSpacing.s2),
                  child: _HandbookCard(item: item),
                )),
          ],
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (statusVariant) {
      case _TrustStatusVariant.ok:
        return BcgColors.success;
      case _TrustStatusVariant.warn:
        return BcgColors.caution;
      case _TrustStatusVariant.info:
        return BcgColors.info;
    }
  }
}

class _HandbookItem {
  const _HandbookItem({required this.question, required this.answer});
  final String question;
  final String answer;
}

class _HandbookCard extends StatelessWidget {
  const _HandbookCard({required this.item});
  final _HandbookItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s3 + 2),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: BcgColors.fg,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.answer,
            style: TextStyle(
              fontSize: 13,
              color: BcgColors.fgMuted,
            ),
          ),
        ],
      ),
    );
  }
}

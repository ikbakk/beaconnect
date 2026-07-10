import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

class TrustCenterScreen extends ConsumerWidget {
  const TrustCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(appSessionProvider);
    final permissions = ref.watch(permissionStatusProvider);
    final batterySaver = ref.watch(batterySaverEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trust Center')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionCard(
            title: 'Our Connection',
            explain: 'Beaconnect works best when both people choose to share.',
            status: session.hasPartner ? 'Connected' : 'Not connected yet',
            actionLabel: session.hasPartner ? 'Connected with care' : 'Pair when ready',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Sharing',
            explain: 'Sharing is mutual. Live sharing is temporary. Check-ins are intentional.',
            status: batterySaver.when(
              data: (enabled) => enabled ? 'Battery Saver Mode is on' : 'Battery Saver Mode is off',
              error: (_, _) => 'We will check again automatically.',
              loading: () => 'Checking gently…',
            ),
            actionLabel: 'Toggle battery saver',
            onAction: () async {
              final enabled = await ref.read(batterySaverEnabledProvider.future);
              await ref.read(toggleBatterySaverUseCaseProvider).call(!enabled);
              ref.invalidate(batterySaverEnabledProvider);
            },
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Privacy',
            explain: 'What you share stays between the two people in the relationship.',
            status: 'No public profiles. No public discovery.',
            actionLabel: 'Protected by design',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'History',
            explain: 'Detailed history is kept short so the relationship stays more important than the record.',
            status: 'Detailed history stays for 3 days.',
            actionLabel: 'Kept short on purpose',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Permissions',
            explain: 'Beaconnect explains why sharing helps before asking.',
            status: permissions.when(
              data: (value) => value.isReadyForSharing
                  ? 'Sharing is ready.'
                  : 'Sharing works best when permission is enabled.',
              error: (_, _) => 'We will check again automatically.',
              loading: () => 'Checking gently…',
            ),
            actionLabel: 'Review status',
            onAction: () {},
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'How Beaconnect Works',
            explain: 'Why consent matters, why not every movement is shown, and why updates may be delayed.',
            status: 'Built for reassurance, not surveillance.',
            actionLabel: 'Understood',
            onAction: () {},
          ),
          const SizedBox(height: 24),
          Text(
            'Leave more informed, never more worried.',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.explain,
    required this.status,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String explain;
  final String status;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(explain, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(status, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

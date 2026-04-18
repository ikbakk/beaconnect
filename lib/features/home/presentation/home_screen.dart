import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../check_in/presentation/check_in_button.dart';
import '../../place_snapshot/application/place_snapshot_controller.dart';
import '../../request_check_in/presentation/request_check_in_button.dart';
import '../domain/home_state_variant.dart';
import 'widgets/home_update_card.dart';
import 'widgets/partner_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final snapshot = ref.watch(homeSnapshotProvider);
    final placeState = ref.watch(placeSnapshotControllerProvider);
    final placeController = ref.read(placeSnapshotControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: snapshot.when(
          data: (home) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Semantics(
                label: 'Partner status card',
                child: PartnerCard(summary: home.partnerSummary),
              ),
              const SizedBox(height: 24),
              const CheckInButton(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: RequestCheckInButton(
                      enabled: home.variant != HomeStateVariant.noPartner,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: home.variant == HomeStateVariant.noPartner
                          ? null
                          : () => context.go('/live-sharing'),
                      child: const Text('Start Live'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent updates', style: theme.textTheme.titleMedium),
                  TextButton(
                    onPressed: () => context.go('/updates'),
                    child: const Text('View all'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (home.updates.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No new updates yet.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                for (final update in home.updates) ...[
                  HomeUpdateCard(update: update),
                  const SizedBox(height: 12),
                ],
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current place', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        home.placeSnapshot?.placeLabel ?? 'No current place yet.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        home.placeSnapshot == null
                            ? 'Capture a manual snapshot when you are ready.'
                            : 'Showing your most recent update from ${home.placeSnapshot!.placeLabel}.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
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
                          child: const Text('Update current place'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/widget'),
                      child: const Text('Widget preview'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/settings'),
                      child: const Text('Settings'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Something did not go as expected.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(homeSnapshotProvider);
                    ref.invalidate(updatesProvider);
                  },
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
          loading: () => Center(
            child: Text(
              'Showing your most recent update…',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}

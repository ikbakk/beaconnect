import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../design/colors/bcg_colors.dart';
import '../../../design/components/bcg_app_header.dart';
import '../../../design/spacing/bcg_spacing.dart';
import '../../check_in/application/check_in_controller.dart';
import '../application/get_widget_snapshot_use_case.dart';
import 'widget_card.dart';

/// Widget preview screen - matches design/prototype/beaconnect-app.html
class WidgetPreviewScreen extends ConsumerWidget {
  const WidgetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeSnapshot = ref.watch(homeSnapshotProvider);
    final session = ref.watch(appSessionProvider);
    final controller = ref.read(checkInControllerProvider.notifier);
    const useCase = GetWidgetSnapshotUseCase();
    final partnerName = session.currentPair?.partnerDisplayName ?? 'your partner';

    return Scaffold(
      backgroundColor: BcgColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            BcgAppHeader(
              title: 'Widget preview',
              onBack: () => context.pop(),
            ),

            // Content
            Expanded(
              child: homeSnapshot.when(
                data: (snapshot) {
                  final widgetSnapshot = useCase(snapshot);
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(BcgSpacing.s5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Widget preview
                          SizedBox(
                            height: 200,
                            child: BeaconWidgetCard(
                              snapshot: widgetSnapshot,
                              onImOkay: () async {
                                await controller.sendCheckIn();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '$partnerName now knows you\'re around.',
                                      ),
                                    ),
                                  );
                                }
                                controller.reset();
                              },
                            ),
                          ),

                          const SizedBox(height: BcgSpacing.s8),

                          // Android preview frame
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                BcgColors.surface,
                                BcgColors.surfaceVariant,
                                0.6,
                              )!,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: BcgColors.outline),
                            ),
                            child: SizedBox(
                              height: 120,
                              width: 200,
                              child: _CompactWidgetPreview(
                                name: widgetSnapshot.name,
                                status: widgetSnapshot.statusSentence,
                                freshness: widgetSnapshot.freshnessSentence,
                              ),
                            ),
                          ),

                          const SizedBox(height: BcgSpacing.s4),

                          Text(
                            'On Android home screen',
                            style: TextStyle(
                              fontFamily: 'IBM Plex Mono',
                              fontSize: 10,
                              color: BcgColors.fgMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Something did not go as expected.',
                    style: TextStyle(
                      fontSize: 16,
                      color: BcgColors.fg,
                    ),
                  ),
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
}

/// Compact widget preview for Android home screen
class _CompactWidgetPreview extends StatelessWidget {
  const _CompactWidgetPreview({
    required this.name,
    required this.status,
    required this.freshness,
  });

  final String name;
  final String status;
  final String freshness;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BcgColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BcgColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '$name ★',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: BcgColors.fg,
                ),
              ),
            ],
          ),
          Text(
            status,
            style: const TextStyle(
              fontSize: 11,
              color: BcgColors.fg,
            ),
          ),
          Text(
            freshness,
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 9,
              color: BcgColors.fgMuted,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: BcgColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "I'm Okay",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: BcgColors.primaryFg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

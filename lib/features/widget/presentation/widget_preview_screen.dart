import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../check_in/application/check_in_controller.dart';
import '../application/get_widget_snapshot_use_case.dart';
import 'widget_card.dart';

class WidgetPreviewScreen extends ConsumerWidget {
  const WidgetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final homeSnapshot = ref.watch(homeSnapshotProvider);
    final controller = ref.read(checkInControllerProvider.notifier);
    const useCase = GetWidgetSnapshotUseCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Widget preview')),
      body: homeSnapshot.when(
        data: (snapshot) {
          final widgetSnapshot = useCase(snapshot);
          return Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 220,
              child: BeaconWidgetCard(
                snapshot: widgetSnapshot,
                onImOkay: () async {
                  await controller.sendCheckIn();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sarah now knows you\'re around.'),
                      ),
                    );
                  }
                  controller.reset();
                },
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(
            'Something did not go as expected.',
            style: theme.textTheme.bodyLarge,
          ),
        ),
        loading: () => Center(
          child: Text(
            'Showing your most recent update…',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

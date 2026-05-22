import 'package:flutter/material.dart';

import '../domain/widget_snapshot.dart';

class BeaconWidgetCard extends StatelessWidget {
  const BeaconWidgetCard({
    super.key,
    required this.snapshot,
    required this.onImOkay,
  });

  final WidgetSnapshot snapshot;
  final VoidCallback onImOkay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(snapshot.name, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(snapshot.statusSentence, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(snapshot.freshnessSentence, style: theme.textTheme.bodyMedium),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onImOkay,
                child: const Text("I'm Okay"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

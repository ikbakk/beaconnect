import 'package:flutter/material.dart';

import '../../domain/partner_summary.dart';

class PartnerCard extends StatelessWidget {
  const PartnerCard({super.key, required this.summary});

  final PartnerSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(summary.name, style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(summary.statusSentence, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              summary.freshnessSentence,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../updates/domain/update_story.dart';

class HomeUpdateCard extends StatelessWidget {
  const HomeUpdateCard({super.key, required this.update});

  final UpdateStory update;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(update.timeGroup, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(update.title, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(update.story, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(update.place, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

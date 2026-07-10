import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';

class UpdatesScreen extends ConsumerWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updates = ref.watch(updatesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Updates')),
      body: updates.when(
        data: (items) {
          if (items.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('No new updates yet.', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'We will keep you updated when something meaningful happens.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("That's everything for today.", style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'We will keep you updated when something meaningful happens.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final item = items[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.timeGroup, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(item.title, style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 4),
                      Text(item.story, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(item.place, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: items.length + 1,
          );
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'We could not load new updates just yet.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.invalidate(updatesProvider),
                  child: const Text('Try again'),
                ),
              ],
            ),
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

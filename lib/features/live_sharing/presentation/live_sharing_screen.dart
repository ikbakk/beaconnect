import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/live_sharing_controller.dart';

class LiveSharingScreen extends ConsumerStatefulWidget {
  const LiveSharingScreen({super.key});

  @override
  ConsumerState<LiveSharingScreen> createState() => _LiveSharingScreenState();
}

class _LiveSharingScreenState extends ConsumerState<LiveSharingScreen> {
  int _minutes = 30;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(liveSharingControllerProvider);
    final controller = ref.read(liveSharingControllerProvider.notifier);
    final session = state.session;

    return Scaffold(
      appBar: AppBar(title: const Text('Start Live')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a duration', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 15, label: Text('15m')),
                ButtonSegment(value: 30, label: Text('30m')),
                ButtonSegment(value: 60, label: Text('60m')),
              ],
              selected: {_minutes},
              onSelectionChanged: (values) {
                setState(() {
                  _minutes = values.first;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Optional reason',
                hintText: 'Going home',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (session != null) ...[
              Text('Sharing live.', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                session.isPaused
                    ? 'Live sharing is paused.'
                    : '${session.minutesRemaining} minutes remaining.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: state.isWorking ? null : () => controller.pause(),
                      child: const Text('Pause'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: state.isWorking ? null : () => controller.end(),
                      child: const Text('End'),
                    ),
                  ),
                ],
              ),
            ] else
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isWorking
                      ? null
                      : () => controller.start(
                            minutes: _minutes,
                            reason: _reasonController.text.trim(),
                          ),
                  child: const Text('Start'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

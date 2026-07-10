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
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(liveSharingControllerProvider.notifier).load(),
    );
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = ref.read(liveSharingControllerProvider).message;
      if (!mounted || message == null) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      controller.clearMessage();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Start Live')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a duration', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Semantics(
              label: 'Select sharing duration',
              child: SegmentedButton<int>(
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
              Text(
                session.isPaused ? 'Sharing is currently paused.' : 'Sharing live.',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (session.reason case final reason? when reason.isNotEmpty) ...[
                Text(reason, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 8),
              ],
              Text(
                session.isPaused
                    ? 'Resume whenever both of you are ready.'
                    : '${session.minutesRemaining} minutes remaining.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Semantics(
                      label: session.isPaused ? 'Resume sharing' : 'Pause sharing',
                      child: OutlinedButton(
                        onPressed: state.isWorking
                            ? null
                            : session.isPaused
                                ? () => controller.resume()
                                : () => controller.pause(),
                        child: Text(session.isPaused ? 'Resume' : 'Pause'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Semantics(
                      label: 'End sharing',
                      child: FilledButton(
                        onPressed: state.isWorking ? null : () => controller.end(),
                        child: const Text('End'),
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Semantics(
                label: 'Start sharing for $_minutes minutes',
                child: SizedBox(
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
              ),
          ],
        ),
      ),
    );
  }
}

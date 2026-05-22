import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../domain/my_beacon_preferences.dart';

class MyBeaconScreen extends ConsumerStatefulWidget {
  const MyBeaconScreen({super.key});

  @override
  ConsumerState<MyBeaconScreen> createState() => _MyBeaconScreenState();
}

class _MyBeaconScreenState extends ConsumerState<MyBeaconScreen> {
  final _messageController = TextEditingController();
  String _pairSymbol = '★';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final prefs = ref.watch(myBeaconPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Beacon')),
      body: prefs.when(
        data: (preferences) {
          if (_messageController.text.isEmpty) {
            _messageController.text = preferences.checkInMessage;
            _pairSymbol = preferences.pairSymbol;
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _PreferenceCard(
                title: 'Check-in messages',
                currentChoice: _messageController.text,
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Check-in message',
                    hintText: 'let {partner} know they are around.',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _PreferenceCard(
                title: 'Pair symbol',
                currentChoice: _pairSymbol,
                child: SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: '★', label: Text('★')),
                    ButtonSegment(value: '✦', label: Text('✦')),
                    ButtonSegment(value: '♥', label: Text('♥')),
                  ],
                  selected: {_pairSymbol},
                  onSelectionChanged: (value) {
                    setState(() {
                      _pairSymbol = value.first;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await ref.read(saveMyBeaconPreferencesUseCaseProvider).call(
                          MyBeaconPreferences(
                            pairSymbol: _pairSymbol,
                            checkInMessage: _messageController.text.trim().isEmpty
                                ? 'let {partner} know they are around.'
                                : _messageController.text.trim(),
                          ),
                        );
                    ref.invalidate(myBeaconPreferencesProvider);
                    ref.invalidate(homeSnapshotProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your choices were updated.')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Personalize Beaconnect without changing what it promises to both people.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          );
        },
        error: (_, _) => Center(
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

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.title,
    required this.currentChoice,
    required this.child,
  });

  final String title;
  final String currentChoice;
  final Widget child;

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
            Text(currentChoice, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

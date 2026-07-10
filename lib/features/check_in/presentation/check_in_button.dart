import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/check_in_controller.dart';
import '../domain/check_in_status.dart';

class CheckInButton extends ConsumerWidget {
  const CheckInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkInControllerProvider);
    final controller = ref.read(checkInControllerProvider.notifier);

    final label = switch (state.status) {
      CheckInStatus.sending => 'Letting ${state.partnerName} know…',
      CheckInStatus.success => '${state.partnerName} now knows you\'re around.',
      CheckInStatus.cooldown => 'You recently checked in.',
      CheckInStatus.unavailable => "I'm Okay",
      CheckInStatus.idle => "I'm Okay",
    };

    return Semantics(
      label: label,
      child: FilledButton(
        onPressed: state.isBusy
            ? null
            : () async {
                await controller.sendCheckIn();
                if (!context.mounted) {
                  return;
                }
                final nextState = ref.read(checkInControllerProvider);
                final message = nextState.message;
                if (message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
                controller.reset();
              },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}

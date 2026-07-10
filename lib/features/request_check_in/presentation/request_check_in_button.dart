import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/request_check_in_controller.dart';

class RequestCheckInButton extends ConsumerWidget {
  const RequestCheckInButton({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestCheckInControllerProvider);
    final controller = ref.read(requestCheckInControllerProvider.notifier);

    return Semantics(
      label: 'Request a check-in from your partner',
      child: OutlinedButton(
        onPressed: !enabled || state.isSending
            ? null
            : () async {
                await controller.send();
                final message = ref.read(requestCheckInControllerProvider).lastMessage;
                if (context.mounted && message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
                controller.clearMessage();
              },
        child: const Text('Request Check-in'),
      ),
    );
  }
}

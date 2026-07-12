import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design/colors/bcg_colors.dart';
import '../../../../design/spacing/bcg_spacing.dart';
import '../../../../design/spacing/bcg_radius.dart';
import '../application/request_check_in_controller.dart';

/// Request Check-in button - matches design/prototype/beaconnect.css
/// Secondary outlined button for requesting partner check-in
class RequestCheckInButton extends ConsumerStatefulWidget {
  const RequestCheckInButton({super.key, required this.enabled});

  final bool enabled;

  @override
  ConsumerState<RequestCheckInButton> createState() =>
      _RequestCheckInButtonState();
}

class _RequestCheckInButtonState extends ConsumerState<RequestCheckInButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestCheckInControllerProvider);
    final controller = ref.read(requestCheckInControllerProvider.notifier);

    final isDisabled = !widget.enabled || state.isSending;

    return Semantics(
      label: 'Request a check-in from your partner',
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _isPressed = false),
        onTapCancel:
            isDisabled ? null : () => setState(() => _isPressed = false),
        onTap: isDisabled
            ? null
            : () async {
                await controller.send();
                final message =
                    ref.read(requestCheckInControllerProvider).lastMessage;
                if (context.mounted && message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
                controller.clearMessage();
              },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: isDisabled ? 0.45 : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
            transformAlignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: BcgSpacing.s4,
                vertical: BcgSpacing.s3,
              ),
              decoration: BoxDecoration(
                color:
                    _isPressed ? BcgColors.outline : BcgColors.surfaceVariant,
                borderRadius: BcgRadius.borderMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: BcgColors.fg,
                  ),
                  const SizedBox(width: BcgSpacing.s2),
                  Flexible(
                    child: Text(
                      state.isSending ? 'Sending…' : 'Request Check-in',
                      style: const TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: BcgColors.fg,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

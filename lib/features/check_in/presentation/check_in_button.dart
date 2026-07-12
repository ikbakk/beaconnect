import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design/colors/bcg_colors.dart';
import '../../../../design/spacing/bcg_spacing.dart';
import '../../../../design/spacing/bcg_radius.dart';
import '../application/check_in_controller.dart';
import '../domain/check_in_status.dart';

/// I'm Okay button - matches design/prototype/beaconnect.css
/// Primary CTA button with terracotta color
class CheckInButton extends ConsumerStatefulWidget {
  const CheckInButton({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  ConsumerState<CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends ConsumerState<CheckInButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkInControllerProvider);
    final controller = ref.read(checkInControllerProvider.notifier);

    final isBusy = state.status == CheckInStatus.sending;

    return Semantics(
      label: _getLabel(state),
      child: GestureDetector(
        onTapDown: isBusy ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isBusy ? null : (_) => setState(() => _isPressed = false),
        onTapCancel: isBusy ? null : () => setState(() => _isPressed = false),
        onTap: isBusy
            ? null
            : () async {
                await controller.sendCheckIn();
                if (!context.mounted) return;
                final nextState = ref.read(checkInControllerProvider);
                final message = nextState.message;
                if (message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
                controller.reset();
                widget.onComplete?.call();
              },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
          transformAlignment: Alignment.center,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: BcgSpacing.s6,
              vertical: BcgSpacing.s5 - 2, // 18px
            ),
            decoration: BoxDecoration(
              color: _isPressed ? BcgColors.primaryHover : BcgColors.primary,
              borderRadius: BcgRadius.borderLg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isBusy) ...[
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(BcgColors.primaryFg),
                    ),
                  ),
                  const SizedBox(width: BcgSpacing.s2),
                ],
                Flexible(
                  child: Text(
                    _getLabel(state),
                    style: const TextStyle(
                      fontFamily: 'IBM Plex Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.01,
                      color: BcgColors.primaryFg,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLabel(CheckInState state) {
    return switch (state.status) {
      CheckInStatus.sending => 'Letting ${state.partnerName} know…',
      CheckInStatus.success => '${state.partnerName} now knows you\'re around.',
      CheckInStatus.cooldown => 'You recently checked in.',
      CheckInStatus.unavailable => "I'm Okay",
      CheckInStatus.idle => "I'm Okay",
    };
  }
}

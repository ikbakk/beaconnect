import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_radius.dart';
import '../spacing/bcg_spacing.dart';
import '../typography/bcg_typography.dart';

/// Map preview card showing partner location
class BcgMapPreview extends StatelessWidget {
  const BcgMapPreview({
    super.key,
    required this.label,
    required this.child,
    this.onTap,
  });

  final String label;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: BcgColors.surfaceVariant,
          borderRadius: BcgRadius.borderMd,
          border: Border.all(color: BcgColors.outline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Map content
            Positioned.fill(child: child),

            // Label overlay
            Positioned(
              left: BcgSpacing.s3,
              bottom: BcgSpacing.s3,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BcgSpacing.s3,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: BcgColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(BcgRadius.sm),
                ),
                child: Text(
                  label,
                  style: BcgTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Live map preview with pulsing indicator
class BcgLiveMapPreview extends StatelessWidget {
  const BcgLiveMapPreview({
    super.key,
    required this.label,
    required this.liveDuration,
    required this.child,
  });

  final String label;
  final String liveDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
        border: Border.all(color: BcgColors.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Map content
          Positioned.fill(child: child),

          // Live badge
          Positioned(
            right: BcgSpacing.s3 + 4,
            top: BcgSpacing.s3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: BcgColors.primary,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PulsingDot(),
                  const SizedBox(width: 5),
                  Text(
                    'LIVE · $liveDuration',
                    style: BcgTypography.monoCaption.copyWith(
                      color: BcgColors.primaryFg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4 + 0.6 * _controller.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

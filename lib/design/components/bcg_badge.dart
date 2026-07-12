import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../typography/bcg_typography.dart';

/// Status badge variants for partner card
enum BcgBadgeVariant {
  live,
  paused,
  info,
  success,
}

/// A small status badge (e.g., "Live", "Paused")
class BcgBadge extends StatelessWidget {
  const BcgBadge({
    super.key,
    required this.label,
    required this.variant,
    this.icon,
  });

  final String label;
  final BcgBadgeVariant variant;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ] else if (_showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: BcgTypography.monoCaption.copyWith(color: _textColor),
          ),
        ],
      ),
    );
  }

  bool get _showDot =>
      variant == BcgBadgeVariant.live ||
      variant == BcgBadgeVariant.paused ||
      variant == BcgBadgeVariant.info;

  Color get _backgroundColor {
    switch (variant) {
      case BcgBadgeVariant.live:
        return BcgColors.criticalBg;
      case BcgBadgeVariant.paused:
        return BcgColors.cautionBg;
      case BcgBadgeVariant.info:
        return BcgColors.infoBg;
      case BcgBadgeVariant.success:
        return BcgColors.successBg;
    }
  }

  Color get _textColor {
    switch (variant) {
      case BcgBadgeVariant.live:
        return BcgColors.critical;
      case BcgBadgeVariant.paused:
        return BcgColors.caution;
      case BcgBadgeVariant.info:
        return BcgColors.info;
      case BcgBadgeVariant.success:
        return BcgColors.success;
    }
  }

  Color get _dotColor {
    switch (variant) {
      case BcgBadgeVariant.live:
        return BcgColors.critical;
      case BcgBadgeVariant.paused:
        return BcgColors.caution;
      case BcgBadgeVariant.info:
        return BcgColors.info;
      case BcgBadgeVariant.success:
        return BcgColors.success;
    }
  }
}

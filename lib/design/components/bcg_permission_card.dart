import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';
import 'bcg_buttons.dart';

/// Permission status variant
enum BcgPermissionStatus {
  ok,
  warn,
}

/// Card showing why a permission is needed
class BcgPermissionCard extends StatelessWidget {
  const BcgPermissionCard({
    super.key,
    required this.whyTitle,
    required this.description,
    required this.statusLabel,
    this.status = BcgPermissionStatus.ok,
    this.actionLabel,
    this.onAction,
  });

  final String whyTitle;
  final String description;
  final String statusLabel;
  final BcgPermissionStatus status;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s5),
      margin: const EdgeInsets.only(bottom: BcgSpacing.s3),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            whyTitle,
            style: BcgTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: BcgSpacing.s2),
          Text(
            description,
            style: BcgTypography.labelSmall,
          ),
          const SizedBox(height: BcgSpacing.s3),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: _statusBackgroundColor,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status == BcgPermissionStatus.ok)
                  Icon(
                    Icons.check_circle,
                    size: 12,
                    color: _statusColor,
                  ),
                if (status == BcgPermissionStatus.warn)
                  Icon(
                    Icons.warning,
                    size: 12,
                    color: _statusColor,
                  ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: BcgTypography.monoCaption.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            BcgButton(
              label: actionLabel!,
              onPressed: onAction!,
              variant: BcgButtonVariant.secondary,
            ),
          ],
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (status) {
      case BcgPermissionStatus.ok:
        return BcgColors.success;
      case BcgPermissionStatus.warn:
        return BcgColors.caution;
    }
  }

  Color get _statusBackgroundColor {
    switch (status) {
      case BcgPermissionStatus.ok:
        return BcgColors.successBg;
      case BcgPermissionStatus.warn:
        return BcgColors.cautionBg;
    }
  }
}

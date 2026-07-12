import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Module item in My Beacon settings
class BcgBeaconModule extends StatelessWidget {
  const BcgBeaconModule({
    super.key,
    required this.label,
    required this.description,
    this.currentLabel,
    this.chips,
    this.trailing,
    this.onCustomize,
  });

  final String label;
  final String description;
  final String? currentLabel;
  final List<Widget>? chips;
  final Widget? trailing;
  final VoidCallback? onCustomize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: BcgTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: BcgSpacing.s1),
          Text(
            description,
            style: BcgTypography.labelSmall,
          ),

          if (currentLabel != null || chips != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            Wrap(
              spacing: BcgSpacing.s2,
              runSpacing: BcgSpacing.s2,
              children: [
                if (currentLabel != null)
                  Text(
                    'Current:',
                    style: BcgTypography.labelSmall,
                  ),
                if (chips != null) ...chips!,
              ],
            ),
          ],

          if (trailing != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            trailing!,
          ],

          if (onCustomize != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            GestureDetector(
              onTap: onCustomize,
              child: Text(
                'Customize →',
                style: BcgTypography.buttonMedium.copyWith(
                  color: BcgColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small chip/tag used in beacon modules
class BcgChip extends StatelessWidget {
  const BcgChip({
    super.key,
    required this.label,
    this.icon,
  });

  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BcgSpacing.s2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BorderRadius.circular(BcgRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: const IconThemeData(
                color: BcgColors.fgMuted,
                size: 12,
              ),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: BcgTypography.monoCaption.copyWith(
              fontWeight: FontWeight.w500,
              color: BcgColors.fg,
            ),
          ),
        ],
      ),
    );
  }
}

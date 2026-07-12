import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../typography/bcg_typography.dart';

/// Screen header with title and subtitle
class BcgHeader extends StatelessWidget {
  const BcgHeader({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.onBack,
    this.backIcon,
  });

  final String? label;
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        BcgSpacing.s5,
        BcgSpacing.s3,
        BcgSpacing.s5,
        BcgSpacing.s3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button row
          if (onBack != null) ...[
            GestureDetector(
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: BcgSpacing.s1,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      backIcon ?? Icons.arrow_back,
                      size: 16,
                      color: BcgColors.fgMuted,
                    ),
                    const SizedBox(width: BcgSpacing.s1),
                    Text(
                      'Back',
                      style: BcgTypography.bodySmall.copyWith(
                        color: BcgColors.fgMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: BcgSpacing.s2),
          ],

          // Label
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: BcgSpacing.s1),
              child: Text(
                label!,
                style: BcgTypography.monoSmall.copyWith(
                  letterSpacing: 0.08,
                ),
              ),
            ),

          // Title
          Text(
            title,
            style: BcgTypography.displayMedium,
          ),

          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: BcgSpacing.s1),
            Text(
              subtitle!,
              style: BcgTypography.labelSmall,
            ),
          ],
        ],
      ),
    );
  }
}

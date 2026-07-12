import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';
import 'bcg_badge.dart';

/// Card showing partner's current status
class BcgPartnerCard extends StatelessWidget {
  const BcgPartnerCard({
    super.key,
    required this.partnerName,
    required this.status,
    required this.freshness,
    this.symbol = '★',
    this.badge,
    this.onTap,
  });

  final String partnerName;
  final String status;
  final String freshness;
  final String symbol;
  final BcgBadge? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BcgColors.surface,
      borderRadius: BcgRadius.borderLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: BcgRadius.borderLg,
        child: Container(
          padding: const EdgeInsets.all(BcgSpacing.s6),
          decoration: BoxDecoration(
            borderRadius: BcgRadius.borderLg,
            border: Border.all(color: BcgColors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Partner name with symbol
              Row(
                children: [
                  Text(
                    partnerName,
                    style: BcgTypography.displaySmall,
                  ),
                  if (symbol.isNotEmpty) ...[
                    const SizedBox(width: BcgSpacing.s2),
                    Text(
                      symbol,
                      style: BcgTypography.displaySmall.copyWith(
                        color: BcgColors.caution,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: BcgSpacing.s3),

              // Status text
              Text(
                status,
                style: BcgTypography.bodyLarge,
              ),

              // Freshness
              if (freshness.isNotEmpty) ...[
                const SizedBox(height: BcgSpacing.s2),
                Text(
                  freshness,
                  style: BcgTypography.mono,
                ),
              ],

              // Badge
              if (badge != null) ...[
                const SizedBox(height: BcgSpacing.s3),
                badge!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple card container with optional raised style
class BcgCard extends StatelessWidget {
  const BcgCard({
    super.key,
    this.raised = false,
    this.child,
    this.padding,
    this.onTap,
  });

  final bool raised;
  final Widget? child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: raised ? BcgColors.surface : BcgColors.surfaceVariant,
      borderRadius: raised ? BcgRadius.borderLg : BcgRadius.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: raised ? BcgRadius.borderLg : BcgRadius.borderMd,
        child: Container(
          padding: padding ?? const EdgeInsets.all(BcgSpacing.s5),
          decoration: BoxDecoration(
            borderRadius:
                raised ? BcgRadius.borderLg : BcgRadius.borderMd,
            border: raised ? Border.all(color: BcgColors.outline) : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

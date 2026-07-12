import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Home screen widget preview card
class BcgWidgetPreview extends StatelessWidget {
  const BcgWidgetPreview({
    super.key,
    required this.partnerName,
    required this.status,
    required this.freshness,
    this.symbol = '★',
    this.onAction,
  });

  final String partnerName;
  final String status;
  final String freshness;
  final String symbol;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 148,
      padding: const EdgeInsets.all(BcgSpacing.s4 + 2),
      decoration: BoxDecoration(
        color: BcgColors.surface,
        borderRadius: BcgRadius.borderLg,
        border: Border.all(color: BcgColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Partner name
          Row(
            children: [
              Text(
                partnerName,
                style: BcgTypography.bodySmall.copyWith(
                  fontFamily: BcgTypography.fontDisplay,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                symbol,
                style: BcgTypography.bodySmall.copyWith(
                  color: BcgColors.caution,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Status
          Text(
            status,
            style: BcgTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          // Freshness
          Text(
            freshness,
            style: BcgTypography.mono.copyWith(fontSize: 11),
          ),

          const Spacer(),

          // Action button
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: BcgColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "I'm Okay",
                style: BcgTypography.buttonMedium.copyWith(
                  color: BcgColors.primaryFg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact version for Android home screen preview
class BcgWidgetPreviewCompact extends StatelessWidget {
  const BcgWidgetPreviewCompact({
    super.key,
    required this.partnerName,
    required this.status,
    required this.freshness,
    this.symbol = '★',
    this.onAction,
  });

  final String partnerName;
  final String status;
  final String freshness;
  final String symbol;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BcgColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BcgColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$partnerName $symbol',
                style: BcgTypography.labelSmall.copyWith(
                  fontFamily: BcgTypography.fontDisplay,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          Text(
            status,
            style: BcgTypography.labelSmall.copyWith(fontSize: 11),
          ),
          Text(
            freshness,
            style: BcgTypography.mono.copyWith(fontSize: 9),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: BcgColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "I'm Okay",
                style: BcgTypography.buttonSmall.copyWith(
                  color: BcgColors.primaryFg,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Status dot variants for trust sections
enum BcgTrustDotVariant {
  ok,
  warn,
  info,
}

/// Trust section with title, description, and status
class BcgTrustSection extends StatelessWidget {
  const BcgTrustSection({
    super.key,
    required this.title,
    required this.description,
    required this.statusLabel,
    this.statusVariant = BcgTrustDotVariant.ok,
    this.actionLabel,
    this.onAction,
    this.handbookItems,
  });

  final String title;
  final String description;
  final String statusLabel;
  final BcgTrustDotVariant statusVariant;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<BcgTrustSectionHandbookItem>? handbookItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        BcgSpacing.s5,
        BcgSpacing.s4,
        BcgSpacing.s5,
        BcgSpacing.s4,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: BcgTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: BcgSpacing.s2 - 2),
          Text(
            description,
            style: BcgTypography.labelSmall.copyWith(
              height: 1.55,
            ),
          ),
          const SizedBox(height: BcgSpacing.s3),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: BcgColors.surfaceVariant,
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  statusLabel,
                  style: BcgTypography.monoCaption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Action button
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: BcgSpacing.s3),
            GestureDetector(
              onTap: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: BcgTypography.buttonMedium.copyWith(
                      color: BcgColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: BcgColors.primary,
                  ),
                ],
              ),
            ),
          ],

          // Handbook items
          if (handbookItems != null && handbookItems!.isNotEmpty) ...[
            const SizedBox(height: BcgSpacing.s4),
            ...handbookItems!.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: BcgSpacing.s2),
                  child: BcgTrustHandbookItem(
                    question: item.question,
                    answer: item.answer,
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Color get _dotColor {
    switch (statusVariant) {
      case BcgTrustDotVariant.ok:
        return BcgColors.success;
      case BcgTrustDotVariant.warn:
        return BcgColors.caution;
      case BcgTrustDotVariant.info:
        return BcgColors.info;
    }
  }
}

/// Q&A item in the handbook section
class BcgTrustSectionHandbookItem {
  const BcgTrustSectionHandbookItem({
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;
}

class BcgTrustHandbookItem extends StatelessWidget {
  const BcgTrustHandbookItem({
    super.key,
    required this.question,
    required this.answer,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(BcgSpacing.s3 + 2),
      decoration: BoxDecoration(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: BcgTypography.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: BcgSpacing.s1),
          Text(
            answer,
            style: BcgTypography.labelSmall,
          ),
        ],
      ),
    );
  }
}

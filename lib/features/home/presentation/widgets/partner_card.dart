import 'package:flutter/material.dart';
import '../../../../design/colors/bcg_colors.dart';
import '../../../../design/spacing/bcg_spacing.dart';
import '../../../../design/spacing/bcg_radius.dart';
import '../../domain/partner_summary.dart';

/// Partner status card - matches design/prototype/beaconnect.css
/// Shows partner name, symbol, status, freshness, and optional badge
class PartnerCard extends StatelessWidget {
  const PartnerCard({
    super.key,
    required this.summary,
    this.onTap,
  });

  final PartnerSummary summary;
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
                    summary.name,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.03,
                      color: BcgColors.fg,
                    ),
                  ),
                  const SizedBox(width: BcgSpacing.s2),
                  // Pair symbol — sourced from the partner's My Beacon
                  // preferences, not hardcoded. Renders in the same
                  // position as the prototype.
                  Text(
                    summary.pairSymbol,
                    style: TextStyle(
                      fontSize: 16,
                      color: BcgColors.caution,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: BcgSpacing.s3),

              // Status sentence
              Text(
                summary.statusSentence,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.01,
                  height: 1.35,
                  color: BcgColors.fg,
                ),
              ),

              // Freshness sentence
              if (summary.freshnessSentence.isNotEmpty) ...[
                const SizedBox(height: BcgSpacing.s2),
                Text(
                  summary.freshnessSentence,
                  style: const TextStyle(
                    fontFamily: 'IBM Plex Mono',
                    fontSize: 12,
                    color: BcgColors.fgMuted,
                  ),
                ),
              ],

              // Badge (if any)
              if (summary.badgeLabel != null) ...[
                const SizedBox(height: BcgSpacing.s3),
                _Badge(label: summary.badgeLabel!, variant: summary.badgeVariant),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.variant});

  final String label;
  final String variant; // 'live', 'paused', 'info', 'success'

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
          if (_showDot) ...[
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
            style: TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }

  bool get _showDot =>
      variant == 'live' || variant == 'paused' || variant == 'info';

  Color get _backgroundColor {
    switch (variant) {
      case 'live':
        return BcgColors.criticalBg;
      case 'paused':
        return BcgColors.cautionBg;
      case 'info':
        return BcgColors.infoBg;
      case 'success':
        return BcgColors.successBg;
      default:
        return BcgColors.surfaceVariant;
    }
  }

  Color get _textColor {
    switch (variant) {
      case 'live':
        return BcgColors.critical;
      case 'paused':
        return BcgColors.caution;
      case 'info':
        return BcgColors.info;
      case 'success':
        return BcgColors.success;
      default:
        return BcgColors.fgMuted;
    }
  }

  Color get _dotColor => _textColor;
}

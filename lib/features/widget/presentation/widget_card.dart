import 'package:flutter/material.dart';

import '../../../../design/colors/bcg_colors.dart';
import '../../../../design/spacing/bcg_spacing.dart';
import '../../../../design/spacing/bcg_radius.dart';
import '../domain/widget_snapshot.dart';

/// Home screen widget card - matches design/prototype/beaconnect-app.html
class BeaconWidgetCard extends StatelessWidget {
  const BeaconWidgetCard({
    super.key,
    required this.snapshot,
    required this.onImOkay,
  });

  final WidgetSnapshot snapshot;
  final VoidCallback onImOkay;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Partner name with symbol
          Row(
            children: [
              Text(
                snapshot.name,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: BcgColors.fg,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '★',
                style: TextStyle(
                  fontSize: 14,
                  color: BcgColors.caution,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Status
          Text(
            snapshot.statusSentence,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: BcgColors.fg,
            ),
          ),

          // Freshness
          Text(
            snapshot.freshnessSentence,
            style: const TextStyle(
              fontFamily: 'IBM Plex Mono',
              fontSize: 11,
              color: BcgColors.fgMuted,
            ),
          ),

          const Spacer(),

          // Action button
          GestureDetector(
            onTap: onImOkay,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: BcgColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                "I'm Okay",
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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

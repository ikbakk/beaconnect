import 'package:flutter/material.dart';

import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';

class BcgAppHeader extends StatelessWidget {
  const BcgAppHeader({
    super.key,
    required this.title,
    this.label,
    this.subtitle,
    this.backLabel,
    this.onBack,
  });

  final String title;
  final String? label;
  final String? subtitle;
  final String? backLabel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        BcgSpacing.s5,
        BcgSpacing.s3 + 4,
        BcgSpacing.s5,
        BcgSpacing.s4,
      ),
      decoration: const BoxDecoration(
        color: BcgColors.surface,
        border: Border(
          bottom: BorderSide(color: BcgColors.outline, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBack,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, size: 16, color: BcgColors.fgMuted),
                  const SizedBox(width: 4),
                  Text(
                    backLabel ?? 'Back',
                    style: const TextStyle(
                      fontSize: 13,
                      color: BcgColors.fgMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: BcgSpacing.s2),
          ],
          if (label != null) ...[
            Text(
              label!,
              style: const TextStyle(
                fontFamily: 'IBM Plex Mono',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: BcgColors.fgMuted,
                letterSpacing: 0.08,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.03,
              color: BcgColors.fg,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 14,
                color: BcgColors.fgMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Icon color variant for settings row
enum BcgIconVariant {
  defaultIcon,
  primary,
  success,
  info,
}

/// Settings section with header and rows
class BcgSettingsSection extends StatelessWidget {
  const BcgSettingsSection({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<BcgSettingsRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BcgSpacing.s5,
            vertical: BcgSpacing.s3 + 2,
          ),
          child: Text(
            title.toUpperCase(),
            style: BcgTypography.monoSmall.copyWith(
              letterSpacing: 0.08,
            ),
          ),
        ),

        // Rows
        ...rows,
      ],
    );
  }
}

/// Settings row item
class BcgSettingsRow extends StatefulWidget {
  const BcgSettingsRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.icon,
    this.iconVariant = BcgIconVariant.defaultIcon,
    this.trailing,
    this.trailingLabel,
    this.onTap,
  });

  final String label;
  final String? subtitle;
  final Widget icon;
  final BcgIconVariant iconVariant;
  final Widget? trailing;
  final String? trailingLabel;
  final VoidCallback? onTap;

  @override
  State<BcgSettingsRow> createState() => _BcgSettingsRowState();
}

class _BcgSettingsRowState extends State<BcgSettingsRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(BcgSpacing.s4),
          margin: const EdgeInsets.symmetric(horizontal: BcgSpacing.s2),
          decoration: BoxDecoration(
            color:
                _isHovered ? BcgColors.surfaceVariant : Colors.transparent,
            borderRadius: BcgRadius.borderSm,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _iconBackgroundColor,
                  borderRadius: BcgRadius.borderSm,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: _iconColor,
                      size: 18,
                    ),
                    child: widget.icon,
                  ),
                ),
              ),

              const SizedBox(width: BcgSpacing.s3),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: BcgTypography.labelMedium,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        widget.subtitle!,
                        style: BcgTypography.labelSmall,
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing
              if (widget.trailing != null || widget.trailingLabel != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.trailingLabel != null)
                      Text(
                        widget.trailingLabel!,
                        style: BcgTypography.labelSmall,
                      ),
                    if (widget.trailing != null) widget.trailing!,
                  ],
                ),

              // Chevron (if tappable)
              if (widget.onTap != null)
                Padding(
                  padding: const EdgeInsets.only(left: BcgSpacing.s2),
                  child: Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: BcgColors.outlineStrong,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color get _iconBackgroundColor {
    switch (widget.iconVariant) {
      case BcgIconVariant.primary:
        return BcgColors.primary;
      case BcgIconVariant.success:
        return BcgColors.successBg;
      case BcgIconVariant.info:
        return BcgColors.infoBg;
      case BcgIconVariant.defaultIcon:
        return BcgColors.surfaceVariant;
    }
  }

  Color get _iconColor {
    switch (widget.iconVariant) {
      case BcgIconVariant.primary:
        return BcgColors.primaryFg;
      case BcgIconVariant.success:
        return BcgColors.success;
      case BcgIconVariant.info:
        return BcgColors.info;
      case BcgIconVariant.defaultIcon:
        return BcgColors.fg;
    }
  }
}

import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Timeline section label (e.g., "Today", "Yesterday")
class BcgTimelineGroup extends StatelessWidget {
  const BcgTimelineGroup({
    super.key,
    required this.label,
    required this.children,
    this.sublabel,
  });

  final String label;
  final String? sublabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main label
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: BcgSpacing.s5,
            vertical: BcgSpacing.s3,
          ),
          child: Text(
            label.toUpperCase(),
            style: BcgTypography.monoSmall.copyWith(
              color: BcgColors.fgMuted,
              letterSpacing: 0.08,
            ),
          ),
        ),

        // Sub label (e.g., "Morning", "Afternoon")
        if (sublabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: BcgSpacing.s5,
              vertical: BcgSpacing.s2,
            ),
            child: Text(
              sublabel!,
              style: BcgTypography.bodySmall.copyWith(
                color: BcgColors.fgMuted,
              ),
            ),
          ),

        // Children
        ...children,
      ],
    );
  }
}

/// Single update item in the timeline
class BcgUpdateItem extends StatefulWidget {
  const BcgUpdateItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
    this.showArrow = true,
  });

  final Widget icon;
  final String title;
  final String description;
  final String time;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final bool showArrow;

  @override
  State<BcgUpdateItem> createState() => _BcgUpdateItemState();
}

class _BcgUpdateItemState extends State<BcgUpdateItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: BcgSpacing.s2),
          padding: const EdgeInsets.all(BcgSpacing.s4),
          decoration: BoxDecoration(
            color: _isHovered ? BcgColors.surfaceVariant : Colors.transparent,
            borderRadius: BcgRadius.borderSm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.iconBackgroundColor ?? BcgColors.surfaceVariant,
                  borderRadius: BcgRadius.borderSm,
                ),
                child: Center(
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.iconColor ?? BcgColors.fgMuted,
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
                      widget.title,
                      style: BcgTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.description,
                      style: BcgTypography.bodySmall.copyWith(
                        color: BcgColors.fgMuted,
                      ),
                    ),
                  ],
                ),
              ),

              // Time and arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.time,
                    style: BcgTypography.monoSmall,
                  ),
                  if (widget.showArrow) ...[
                    const SizedBox(height: 2),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 120),
                      opacity: _isHovered ? 1.0 : 0.0,
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: BcgColors.fgMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

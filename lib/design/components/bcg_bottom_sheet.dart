import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Bottom sheet overlay with handle
class BcgBottomSheet extends StatelessWidget {
  const BcgBottomSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    this.title,
    this.body,
    this.detail,
    this.actions,
    this.child,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final String? title;
  final String? body;
  final String? detail;
  final List<Widget>? actions;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay
        GestureDetector(
          onTap: onClose,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            color: isOpen
                ? Colors.black.withAlpha(61)
                : Colors.transparent,
          ),
        ),

        // Sheet
        AnimatedPositioned(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          bottom: isOpen ? 0 : -400,
          child: GestureDetector(
            onTap: () {}, // Absorb taps to prevent closing
            child: Material(
              color: BcgColors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(BcgRadius.lg),
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    BcgSpacing.s5,
                    BcgSpacing.s3,
                    BcgSpacing.s5,
                    BcgSpacing.s8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: BcgColors.outlineStrong,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      const SizedBox(height: BcgSpacing.s4),

                      // Content
                      if (child != null)
                        child!
                      else ...[
                        if (title != null) ...[
                          Text(title!, style: BcgTypography.headerTitle),
                          const SizedBox(height: BcgSpacing.s2),
                        ],
                        if (body != null) ...[
                          Text(
                            body!,
                            style: BcgTypography.bodySmall.copyWith(
                              color: BcgColors.fgMuted,
                            ),
                          ),
                          const SizedBox(height: BcgSpacing.s4),
                        ],
                        if (detail != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: BcgSpacing.s4),
                            child: Text(
                              detail!,
                              style: BcgTypography.labelSmall,
                            ),
                          ),
                        if (actions != null && actions!.isNotEmpty) ...[
                          Row(
                            children: actions!
                                .map((action) => Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: actions!.last == action
                                              ? 0
                                              : BcgSpacing.s3,
                                        ),
                                        child: action,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

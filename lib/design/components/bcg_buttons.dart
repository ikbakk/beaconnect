import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Button variants following Beaconnect design system
enum BcgButtonVariant {
  primary,
  secondary,
  ghost,
  link,
}

/// Primary action button (full width, large)
class BcgButton extends StatefulWidget {
  const BcgButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = BcgButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final BcgButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool enabled;

  @override
  State<BcgButton> createState() => _BcgButtonState();
}

class _BcgButtonState extends State<BcgButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel:
          isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        transformAlignment: Alignment.center,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 120),
          opacity: isEnabled ? 1.0 : 0.45,
          child: _buildButtonStyle(),
        ),
      ),
    );
  }

  Widget _buildButtonStyle() {
    switch (widget.variant) {
      case BcgButtonVariant.primary:
        return _buildPrimary();
      case BcgButtonVariant.secondary:
        return _buildSecondary();
      case BcgButtonVariant.ghost:
        return _buildGhost();
      case BcgButtonVariant.link:
        return _buildLink();
    }
  }

  Widget _buildPrimary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: BcgSpacing.s6,
        vertical: BcgSpacing.s5 - 2,
      ),
      decoration: BoxDecoration(
        color: _isPressed ? BcgColors.primaryHover : BcgColors.primary,
        borderRadius: BcgRadius.borderLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.isLoading) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(BcgColors.primaryFg),
              ),
            ),
          ] else if (widget.icon != null) ...[
            IconTheme(
              data: const IconThemeData(
                color: BcgColors.primaryFg,
                size: 20,
              ),
              child: widget.icon!,
            ),
            const SizedBox(width: BcgSpacing.s2),
          ],
          Text(widget.label, style: BcgTypography.buttonLarge.copyWith(
            color: BcgColors.primaryFg,
          )),
        ],
      ),
    );
  }

  Widget _buildSecondary() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BcgSpacing.s4,
        vertical: BcgSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: _isPressed ? BcgColors.outline : BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: _isPressed ? BcgColors.fg : BcgColors.fgMuted,
                size: 20,
              ),
              child: widget.icon!,
            ),
            const SizedBox(width: BcgSpacing.s2),
          ],
          Text(widget.label, style: BcgTypography.buttonMedium.copyWith(
            color: BcgColors.fg,
          )),
        ],
      ),
    );
  }

  Widget _buildGhost() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: BcgSpacing.s4,
        vertical: BcgSpacing.s3,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: _isPressed ? BcgColors.fg : BcgColors.fgMuted,
                size: 20,
              ),
              child: widget.icon!,
            ),
            const SizedBox(width: BcgSpacing.s2),
          ],
          Text(widget.label, style: BcgTypography.buttonMedium.copyWith(
            color: _isPressed ? BcgColors.fg : BcgColors.fgMuted,
          )),
        ],
      ),
    );
  }

  Widget _buildLink() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: BcgSpacing.s2),
      child: Text(
        widget.label,
        style: BcgTypography.buttonMedium.copyWith(
          color: BcgColors.primary,
          decoration: TextDecoration.underline,
          decorationColor: Colors.transparent,
        ),
      ),
    );
  }
}

/// Compact action button for quick actions row
class BcgActionChip extends StatelessWidget {
  const BcgActionChip({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: BcgColors.surfaceVariant,
        borderRadius: BcgRadius.borderMd,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BcgRadius.borderMd,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: BcgSpacing.s4,
              vertical: BcgSpacing.s3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  IconTheme(
                    data: const IconThemeData(
                      color: BcgColors.fgMuted,
                      size: 18,
                    ),
                    child: icon!,
                  ),
                  const SizedBox(width: BcgSpacing.s2),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: BcgTypography.buttonMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';
import '../spacing/bcg_spacing.dart';
import '../spacing/bcg_radius.dart';
import '../typography/bcg_typography.dart';

/// Toast notification that slides up from bottom
class BcgToast extends StatefulWidget {
  const BcgToast({
    super.key,
    required this.message,
    required this.isVisible,
  });

  final String message;
  final bool isVisible;

  @override
  State<BcgToast> createState() => _BcgToastState();
}

class _BcgToastState extends State<BcgToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(BcgToast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: BcgSpacing.s5,
          right: BcgSpacing.s5,
          bottom: BcgSpacing.navH + BcgSpacing.s4,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BcgSpacing.s5,
                  vertical: BcgSpacing.s3,
                ),
                decoration: BoxDecoration(
                  color: BcgColors.fg,
                  borderRadius: BcgRadius.borderMd,
                ),
                child: Text(
                  widget.message,
                  style: BcgTypography.bodySmall.copyWith(
                    color: BcgColors.surface,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Simple toast controller for showing/hiding toast
class BcgToastController extends ChangeNotifier {
  String? _message;
  bool _isVisible = false;

  String? get message => _message;
  bool get isVisible => _isVisible;

  void show(String message) {
    _message = message;
    _isVisible = true;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 2800), () {
      hide();
    });
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }
}

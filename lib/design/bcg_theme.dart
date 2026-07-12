import 'package:flutter/material.dart';

/// Beaconnect motion/animation tokens
/// Derived from design/prototype/beaconnect.css
abstract final class BcgMotion {
  // ── Durations ──────────────────────────────────────────────────────────────

  /// Fast: 120ms - hover states, small interactions
  static const Duration fast = Duration(milliseconds: 120);

  /// Medium: 220ms - general transitions
  static const Duration mid = Duration(milliseconds: 220);

  /// Slow: 320ms - page transitions, modal entry
  static const Duration slow = Duration(milliseconds: 320);

  // ── Curves ─────────────────────────────────────────────────────────────────

  /// Ease out: exits, modal entry (cubic-bezier(0.22, 1, 0.36, 1))
  static const Curve easeOut = Curves.easeOut;

  /// Ease in-out: general transitions (cubic-bezier(0.4, 0, 0.2, 1))
  static const Curve easeInOut = Curves.easeInOut;

  /// Bouncy spring for interactive feedback
  static const Curve spring = Curves.elasticOut;
}

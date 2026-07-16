import 'package:flutter/material.dart';

/// Beaconnect motion/animation tokens.
/// Derived from `design/prototype/beaconnect.css` and
/// `design/tokens/motion-tokens.md`.
///
/// Forbidden: bounce, elastic overshoot, repeated pulse, decorative loops.
/// Do not add a `spring` or `elastic` curve here — see the comment on
/// `BcgMotion.easeOutShort` for the only permissible "decisive" curve.
abstract final class BcgMotion {
  // ── Durations ──────────────────────────────────────────────────────────────

  /// Fast: 120ms - hover states, small interactions
  static const Duration fast = Duration(milliseconds: 120);

  /// Medium: 220ms - general transitions
  static const Duration mid = Duration(milliseconds: 220);

  /// Slow: 320ms - page transitions, modal entry, live-map crossfade
  static const Duration slow = Duration(milliseconds: 320);

  // ── Curves ─────────────────────────────────────────────────────────────────

  /// Ease out: enter, expand, show (cubic-bezier(0.22, 1, 0.36, 1))
  static const Curve easeOut = Curves.easeOut;

  /// Ease in-out: toggle, crossfade (cubic-bezier(0.4, 0, 0.2, 1))
  static const Curve easeInOut = Curves.easeInOut;

  /// Decisive exit: dismiss, collapse (cubic-bezier(0.23, 1, 0.32, 1)).
  /// Use this when an element disappears because the user has already chosen
  /// to dismiss it; pair with a slightly shorter duration than `easeOut`.
  static const Curve easeOutShort = Cubic(0.23, 1.0, 0.32, 1.0);
}

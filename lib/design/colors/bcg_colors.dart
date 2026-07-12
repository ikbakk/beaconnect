import 'package:flutter/material.dart';

/// Beaconnect color palette - matches design/prototype/beaconnect.css
/// Uses warm terracotta primary with soft off-white surfaces
abstract final class BcgColors {
  // ── Surface ────────────────────────────────────────────────────────────────

  /// Main background/surface color
  static const Color surface = Color(0xFFFAF8F5); // oklch(98% 0.003 70)

  /// Card/section background
  static const Color surfaceVariant = Color(0xFFF2EDE6); // oklch(95% 0.005 70)

  /// Navigation bar, overlays
  static const Color surfaceOverlay = Color(0xF0FAF8F5); // oklch(100% 0 0 / 0.94)

  // ── Foreground ─────────────────────────────────────────────────────────────

  /// Primary text color
  static const Color fg = Color(0xFF3A3632); // oklch(26% 0.018 55)

  /// Secondary/muted text
  static const Color fgMuted = Color(0xFF7D7872); // oklch(50% 0.016 55)

  // ── Outline ────────────────────────────────────────────────────────────────

  /// Dividers, card borders
  static const Color outline = Color(0xFFD8D3CB); // oklch(86% 0.008 70)

  /// Stronger outlines (handles, active states)
  static const Color outlineStrong = Color(0xFFB8B3AB); // oklch(72% 0.016 70)

  // ── Primary (terracotta) ──────────────────────────────────────────────────

  /// Main brand/action color
  static const Color primary = Color(0xFFB87348); // oklch(58% 0.055 48)

  /// Primary hover state
  static const Color primaryHover = Color(0xFFA66540); // oklch(54% 0.055 48)

  /// Text on primary
  static const Color primaryFg = Color(0xFFFAF6F2); // oklch(98% 0 0)

  // ── Secondary ─────────────────────────────────────────────────────────────

  /// Secondary actions
  static const Color secondary = Color(0xFF6B9E6A); // oklch(56% 0.055 145)
  static const Color secondaryHover = Color(0xFF5F8E60); // oklch(51% 0.055 145)

  // ── Semantic colors ────────────────────────────────────────────────────────

  /// Success/positive states (sage green)
  static const Color success = Color(0xFF6B9E6A); // oklch(55% 0.055 145)
  static const Color successBg = Color(0xFFEDF5EA); // oklch(95% 0.01 145)

  /// Info/informational states (soft blue)
  static const Color info = Color(0xFF6A8AD4); // oklch(60% 0.09 235)
  static const Color infoBg = Color(0xFFEDF0F9); // oklch(95% 0.016 235)

  /// Caution/warning states (amber)
  static const Color caution = Color(0xFFCCA040); // oklch(70% 0.10 85)
  static const Color cautionBg = Color(0xFFFDF6E3); // oklch(95% 0.016 85)

  /// Critical/urgent states (warm red)
  static const Color critical = Color(0xFFCD6040); // oklch(60% 0.13 25)
  static const Color criticalBg = Color(0xFFFDF1ED); // oklch(96% 0.016 25)
}

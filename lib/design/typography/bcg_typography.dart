import 'package:flutter/material.dart';
import '../colors/bcg_colors.dart';

/// Beaconnect typography system
/// Derived from design/prototype/beaconnect.css
abstract final class BcgTypography {
  // Font families (using system fonts as fallback)
  static const String fontDisplay = 'Plus Jakarta Sans';
  static const String fontBody = 'IBM Plex Sans';
  static const String fontMono = 'IBM Plex Mono';

  // ── Text Styles ────────────────────────────────────────────────────────────

  /// Display headline (Partner card name, onboarding headlines)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.03,
    height: 1.2,
    color: BcgColors.fg,
  );

  /// Display medium (Settings hero title)
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.03,
    height: 1.2,
    color: BcgColors.fg,
  );

  /// Display small (Card title)
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.25,
    color: BcgColors.fg,
  );

  /// Header title (Screen headers)
  static const TextStyle headerTitle = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02,
    height: 1.3,
    color: BcgColors.fg,
  );

  /// Body large (Partner card status)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.35,
    color: BcgColors.fg,
  );

  /// Body medium (General body text)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: BcgColors.fg,
  );

  /// Body small (Descriptions, subtitles)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: BcgColors.fg,
  );

  /// Label (Settings row labels)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: BcgColors.fg,
  );

  /// Label small (Settings row subtitles)
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: BcgColors.fgMuted,
  );

  /// Mono (Freshness text, timestamps, badges)
  static const TextStyle mono = TextStyle(
    fontFamily: fontMono,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: BcgColors.fgMuted,
  );

  /// Mono small (Update times, section labels)
  static const TextStyle monoSmall = TextStyle(
    fontFamily: fontMono,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.08,
    height: 1.4,
    color: BcgColors.fgMuted,
  );

  /// Mono caption (Badges, chips)
  static const TextStyle monoCaption = TextStyle(
    fontFamily: fontMono,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02,
    height: 1.4,
    color: BcgColors.fgMuted,
  );

  /// Eyebrow (Onboarding eyebrow text)
  static const TextStyle eyebrow = TextStyle(
    fontFamily: fontMono,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
    color: BcgColors.primary,
  );

  /// Navigation (Bottom nav labels)
  static const TextStyle navLabel = TextStyle(
    fontFamily: fontBody,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.01,
    height: 1.4,
  );

  /// Button text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.4,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.4,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.01,
    height: 1.4,
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/bcg_colors.dart';

/// Beaconnect typography system.
/// Derived from design/prototype/beaconnect.css.
///
/// Fonts are loaded at runtime via the `google_fonts` package so the
/// canonical `Plus Jakarta Sans` / `IBM Plex Sans` / `IBM Plex Mono` actually
/// render instead of silently falling back to `system-ui` (the previous
/// `const TextStyle(fontFamily: 'Plus Jakarta Sans', ...)` shape). The
/// `fontDisplay` / `fontBody` / `fontMono` string constants are retained
/// for the few callers that build a `TextStyle` inline and need the family
/// name; new code should consume the loaded `TextStyle` fields directly.
abstract final class BcgTypography {
  // Font family identifiers (used only by the rare inline-TextStyle caller)
  static const String fontDisplay = 'Plus Jakarta Sans';
  static const String fontBody = 'IBM Plex Sans';
  static const String fontMono = 'IBM Plex Mono';

  // ── Text Styles ────────────────────────────────────────────────────────────

  /// Display headline (Partner card name, onboarding headlines)
  static final TextStyle displayLarge = GoogleFonts.plusJakartaSans(textStyle: 
      const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.03,
      height: 1.2,
      color: BcgColors.fg,
    ),
  );

  /// Display medium (Settings hero title)
  static final TextStyle displayMedium = GoogleFonts.plusJakartaSans(textStyle: 
      const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.03,
      height: 1.2,
      color: BcgColors.fg,
    ),
  );

  /// Display small (Card title)
  static final TextStyle displaySmall = GoogleFonts.plusJakartaSans(textStyle: 
      const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02,
      height: 1.25,
      color: BcgColors.fg,
    ),
  );

  /// Header title (Screen headers)
  static final TextStyle headerTitle = GoogleFonts.plusJakartaSans(textStyle: 
      const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02,
      height: 1.3,
      color: BcgColors.fg,
    ),
  );

  /// Body large (Partner card status)
  static final TextStyle bodyLarge = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.01,
      height: 1.35,
      color: BcgColors.fg,
    ),
  );

  /// Body medium (General body text)
  static final TextStyle bodyMedium = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.5,
      color: BcgColors.fg,
    ),
  );

  /// Body small (Descriptions, subtitles)
  static final TextStyle bodySmall = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: BcgColors.fg,
    ),
  );

  /// Label (Settings row labels)
  static final TextStyle labelMedium = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: BcgColors.fg,
    ),
  );

  /// Label small (Settings row subtitles)
  static final TextStyle labelSmall = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: BcgColors.fgMuted,
    ),
  );

  /// Mono (Freshness text, timestamps, badges)
  static final TextStyle mono = GoogleFonts.ibmPlexMono(textStyle: 
      const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
      color: BcgColors.fgMuted,
    ),
  );

  /// Mono small (Update times, section labels)
  static final TextStyle monoSmall = GoogleFonts.ibmPlexMono(textStyle: 
      const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.08,
      height: 1.4,
      color: BcgColors.fgMuted,
    ),
  );

  /// Mono caption (Badges, chips)
  static final TextStyle monoCaption = GoogleFonts.ibmPlexMono(textStyle: 
      const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.02,
      height: 1.4,
      color: BcgColors.fgMuted,
    ),
  );

  /// Eyebrow (Onboarding eyebrow text)
  static final TextStyle eyebrow = GoogleFonts.ibmPlexMono(textStyle: 
      const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.4,
      color: BcgColors.primary,
    ),
  );

  /// Navigation (Bottom nav labels)
  static final TextStyle navLabel = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.01,
      height: 1.4,
    ),
  );

  /// Button text
  static final TextStyle buttonLarge = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.01,
      height: 1.4,
    ),
  );

  static final TextStyle buttonMedium = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.01,
      height: 1.4,
    ),
  );

  static final TextStyle buttonSmall = GoogleFonts.ibmPlexSans(textStyle: 
      const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.01,
      height: 1.4,
    ),
  );

  /// Complete TextTheme — drop into `ThemeData.textTheme` so any caller
  /// that relies on `Theme.of(context).textTheme.foo` also gets the loaded
  /// Google Fonts faces instead of the platform default.
  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: displayLarge,
        headlineMedium: displayMedium,
        headlineSmall: displaySmall,
        titleLarge: headerTitle,
        titleMedium: bodyLarge,
        bodyLarge: bodyMedium,
        bodyMedium: bodySmall,
        bodySmall: labelSmall,
        labelLarge: labelMedium,
        labelMedium: mono,
        labelSmall: monoSmall,
      );
}

import 'package:flutter/material.dart';

/// Beaconnect theme - matches design/prototype/beaconnect.css
/// Uses warm terracotta palette and soft off-white surfaces
abstract final class BeaconnectTheme {
  static ThemeData get light {
    // ── Surfaces ──────────────────────────────────────────────────────────────
    const surface = Color(0xFFFAF8F5); // oklch(98% 0.003 70)
    const surfaceVariant = Color(0xFFF2EDE6); // oklch(95% 0.005 70)
    const surfaceOverlay = Color(0xF0FAF8F5); // oklch(100% 0 0 / 0.94)

    // ── Foreground ─────────────────────────────────────────────────────────────
    const fg = Color(0xFF3A3632); // oklch(26% 0.018 55)
    const fgMuted = Color(0xFF7D7872); // oklch(50% 0.016 55)

    // ── Outline ────────────────────────────────────────────────────────────────
    const outline = Color(0xFFD8D3CB); // oklch(86% 0.008 70)

    // ── Primary (terracotta) ──────────────────────────────────────────────────
    const primary = Color(0xFFB87348); // oklch(58% 0.055 48)
    const primaryFg = Color(0xFFFAF6F2); // oklch(98% 0 0)

    // ── Semantic colors ────────────────────────────────────────────────────────
    const success = Color(0xFF6B9E6A); // oklch(55% 0.055 145)

    // ── Border radius ─────────────────────────────────────────────────────────
    const radiusMd = 16.0;
    const radiusLg = 24.0;

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: surface,
      primary: primary,
      onPrimary: primaryFg,
      secondary: success,
      onSecondary: primaryFg,
      onSurface: fg,
      outline: outline,
      surfaceContainerHighest: surfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,

      // ── Text ────────────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        // Display headlines (partner card name, onboarding)
        headlineLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.03,
          height: 1.2,
          color: fg,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.03,
          height: 1.2,
          color: fg,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          height: 1.25,
          color: fg,
        ),
        // Screen headers
        titleLarge: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02,
          height: 1.3,
          color: fg,
        ),
        // Partner card status
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          height: 1.35,
          color: fg,
        ),
        // General body
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: fg,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: fg,
        ),
        // Descriptions
        bodySmall: TextStyle(
          fontSize: 13,
          height: 1.4,
          color: fgMuted,
        ),
        // Mono text (timestamps, badges)
        labelMedium: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: fgMuted,
        ),
        labelSmall: TextStyle(
          fontFamily: 'IBM Plex Mono',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          height: 1.4,
          color: fgMuted,
        ),
      ),

      // ── Cards ───────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: outline),
        ),
      ),

      // ── Buttons ──────────────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryFg,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.01,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          side: const BorderSide(color: outline),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Navigation ──────────────────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: surfaceOverlay,
        indicatorColor: primary.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: fgMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return const IconThemeData(color: fgMuted, size: 24);
        }),
      ),

      // ── Dividers ─────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: outline,
        thickness: 0.5,
        space: 0,
      ),

      // ── Snackbar ─────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: fg,
        contentTextStyle: const TextStyle(
          color: surface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ── Bottom Sheet ─────────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLg)),
        ),
      ),
    );
  }
}

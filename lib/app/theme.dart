import 'package:flutter/material.dart';

abstract final class BeaconnectTheme {
  static ThemeData get light {
    const background = Color(0xFFF7F4EF);
    const surface = Color(0xFFFFFFFF);
    const primary = Color(0xFF5C6F68);
    const secondary = Color(0xFF8A7E72);
    const text = Color(0xFF1F2523);
    const muted = Color(0xFF66706B);
    const outline = Color(0xFFE4DED5);

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      surface: surface,
    ).copyWith(
      primary: primary,
      secondary: secondary,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: text,
      outline: outline,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.4,
          color: text,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: muted,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          side: BorderSide(color: outline),
        ),
      ),
    );
  }
}

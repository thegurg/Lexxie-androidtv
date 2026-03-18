import 'package:flutter/material.dart';

class AppTheme {
  // Cyberpunk / Matrix palette — black + electric purple
  static const Color primaryColor    = Color(0xFFAA00FF); // vivid electric purple
  static const Color primaryGlow     = Color(0xFF7B00CC); // deeper purple for shadows
  static const Color accentCyan      = Color(0xFF00FFCC); // matrix teal accent (used sparingly)
  static const Color scaffoldBg      = Color(0xFF050508); // near-black
  static const Color surfaceColor    = Color(0xFF0D0D14); // dark card/panel bg
  static const Color borderColor     = Color(0xFF2A0050); // dark purple border
  static const Color textPrimary     = Color(0xFFE8D5FF); // soft purple-white
  static const Color textSecondary   = Color(0xFF7755AA); // muted purple
  static const Color textGlow        = Color(0xFFCC88FF); // glowing text purple

  static ThemeData get darkTheme {
    const fontBody    = 'Iceland';      // terminal feel for body/UI text
    const fontDisplay = 'TurretRoad';   // futuristic display titles

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.dark(
        primary:    primaryColor,
        secondary:  accentCyan,
        surface:    surfaceColor,
        onPrimary:  Colors.black,
        onSurface:  textPrimary,
      ),

      // ── Text theme ──────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w800, letterSpacing: 3,
        ),
        displayMedium: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w700, letterSpacing: 2,
        ),
        displaySmall: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w700, letterSpacing: 1.5,
        ),
        headlineLarge: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w700, letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w600, letterSpacing: 1.2,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          fontFamily: fontDisplay, color: textPrimary,
          fontWeight: FontWeight.w600, letterSpacing: 1.0,
        ),
        titleMedium: TextStyle(
          fontFamily: fontBody, color: textPrimary,
          fontWeight: FontWeight.w500, letterSpacing: 0.8,
        ),
        titleSmall: TextStyle(
          fontFamily: fontBody, color: textSecondary, letterSpacing: 0.6,
        ),
        bodyLarge: TextStyle(
          fontFamily: fontBody, color: textPrimary,
          fontSize: 16, letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontBody, color: textSecondary,
          fontSize: 14, letterSpacing: 0.4,
        ),
        bodySmall: TextStyle(
          fontFamily: fontBody, color: textSecondary,
          fontSize: 12, letterSpacing: 0.3,
        ),
        labelLarge: TextStyle(
          fontFamily: fontBody, color: textPrimary,
          fontWeight: FontWeight.w600, letterSpacing: 1.5,
        ),
      ),

      // ── AppBar ───────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: const TextStyle(
          fontFamily: fontDisplay,
          color: primaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          shadows: [
            Shadow(color: primaryColor, blurRadius: 12),
            Shadow(color: primaryGlow, blurRadius: 30),
          ],
        ),
      ),

      // ── Buttons ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          shadowColor: primaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: primaryColor, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: fontDisplay,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            fontSize: 15,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textGlow,
          textStyle: const TextStyle(fontFamily: fontBody, letterSpacing: 1),
        ),
      ),

      // ── Input / Dropdown ─────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        labelStyle: const TextStyle(
          fontFamily: fontBody, color: textSecondary, letterSpacing: 1,
        ),
        hintStyle: const TextStyle(color: textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
      ),

      // ── Dropdown ─────────────────────────────────────────────────
      dropdownMenuTheme: const DropdownMenuThemeData(
        textStyle: TextStyle(fontFamily: fontBody, color: textPrimary),
      ),

      // ── Cards ────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: borderColor),
        ),
      ),

      // ── Divider ──────────────────────────────────────────────────
      dividerColor: borderColor,

      // ── Icon ─────────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: primaryColor),
    );
  }
}

import 'package:flutter/material.dart';

/// Application theme definitions for CivicVoice.
///
/// Designed to follow Material 3 with a clean, civic-inspired design language:
/// - Dark civic navy as primary
/// - Muted forest green as secondary
/// - Off-white / light slate surfaces
/// - Subtle 1px borders and moderate corner radii
/// - Readable, standard typography without gimmicky effects
class AppTheme {
  // Primary Palette
  static const Color primaryNavy = Color(0xFF1B365D);
  static const Color primaryNavyDark = Color(0xFF0F2440);
  static const Color primaryNavyLight = Color(0xFF2C4C7C);

  // Secondary & Accent Palette
  static const Color accentGreen = Color(0xFF2D6A4F);
  static const Color accentGreenLight = Color(0xFFD8F3DC);
  static const Color accentAmber = Color(0xFFB45309);
  static const Color accentAmberLight = Color(0xFFFEF3C7);
  static const Color accentBlue = Color(0xFF0284C7);
  static const Color accentBlueLight = Color(0xFFE0F2FE);

  // Neutral Palette
  static const Color backgroundLight = Color(0xFFF6F8FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF334155);
  static const Color textMuted = Color(0xFF64748B);

  // Status Colors
  static const Color statusSubmitted = Color(0xFF0284C7);
  static const Color statusUnderReview = Color(0xFFD97706);
  static const Color statusInProgress = Color(0xFF7C3AED);
  static const Color statusResolved = Color(0xFF16A34A);
  static const Color statusClosed = Color(0xFF475569);

  // Reusable subtle shadows for cards and containers
  static List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryNavy,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE2E9F3),
        onPrimaryContainer: primaryNavyDark,
        secondary: accentGreen,
        onSecondary: Colors.white,
        secondaryContainer: accentGreenLight,
        onSecondaryContainer: Color(0xFF081C15),
        error: Color(0xFFDC2626),
        onError: Colors.white,
        errorContainer: Color(0xFFFEE2E2),
        onErrorContainer: Color(0xFF7F1D1D),
        surface: surfaceWhite,
        onSurface: textPrimary,
        outline: borderSubtle,
        outlineVariant: borderMedium,
      ),
      scaffoldBackgroundColor: backgroundLight,
      fontFamily: 'Roboto',

      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceWhite,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 1.0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: primaryNavy),
      ),

      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderSubtle, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderSubtle, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryNavy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: textSecondary),
        hintStyle: const TextStyle(fontSize: 13, color: textMuted),
        errorStyle: const TextStyle(fontSize: 11),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNavy,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          side: const BorderSide(color: primaryNavy, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryNavy,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceWhite,
        elevation: 3,
        indicatorColor: const Color(0xFFE2E9F3),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primaryNavy,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryNavy, size: 24);
          }
          return const IconThemeData(color: textSecondary, size: 23);
        }),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surfaceMuted,
        selectedColor: const Color(0xFFE2E9F3),
        secondarySelectedColor: primaryNavy,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

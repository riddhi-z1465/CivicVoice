import 'package:flutter/material.dart';

/// Centralized color definitions for CivicVoice.
/// Strictly follows a restrained civic palette:
/// - Deep Navy as primary
/// - Muted Teal as secondary
/// - Off-white / light slate surfaces
/// - Dark charcoal typography
/// - Muted supporting status tones (no neon, no flashy gradients)
class AppColors {
  // Primary Palette (Deep Civic Teal #185E5E - replaced Navy Blue)
  static const Color primaryNavy = Color(0xFF185E5E); // Main brand color (Deep Teal #185E5E)
  static const Color primaryTeal = Color(0xFF185E5E);
  static const Color primaryNavyDark = Color(0xFF0F3E3E);
  static const Color primaryNavyLight = Color(0xFF237676);
  static const Color primaryContainer = Color(0xFFE2EFEF);

  // Secondary Palette (Muted Forest / Teal)
  static const Color secondaryTeal = Color(0xFF266E64);
  static const Color secondaryDark = Color(0xFF194D46);
  static const Color secondaryContainer = Color(0xFFE5F1EE);

  // Background & Surfaces (Off-white / light slate)
  static const Color background = Color(0xFFF8F9FA);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F4F6);
  static const Color surfaceSubtle = Color(0xFFF8FAFC);

  // Borders & Dividers
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);

  // Typography (Dark charcoal & neutral slates)
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Status & Semantic Colors (Restrained, accessible, muted)
  static const Color statusSubmitted = Color(0xFF185E5E); // Deep Teal
  static const Color statusSubmittedBg = Color(0xFFE8F3F3);
  static const Color statusSubmittedBorder = Color(0xFFBCE0E0);

  static const Color statusUnderReview = Color(0xFFB45309); // Muted amber
  static const Color statusUnderReviewBg = Color(0xFFFFFBEB);
  static const Color statusUnderReviewBorder = Color(0xFFFDE68A);

  static const Color statusInProgress = Color(0xFF6D28D9); // Muted violet
  static const Color statusInProgressBg = Color(0xFFF5F3FF);
  static const Color statusInProgressBorder = Color(0xFFDDD6FE);

  static const Color statusResolved = Color(0xFF15803D); // Muted green
  static const Color statusResolvedBg = Color(0xFFF0FDF4);
  static const Color statusResolvedBorder = Color(0xFFBBF7D0);

  static const Color statusClosed = Color(0xFF475569); // Slate
  static const Color statusClosedBg = Color(0xFFF8FAFC);
  static const Color statusClosedBorder = Color(0xFFE2E8F0);

  // Alert & Feedback
  static const Color errorRed = Color(0xFFC53030);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFECACA);

  static const Color warningAmber = Color(0xFFB45309);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color successGreen = Color(0xFF15803D);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color successBorder = Color(0xFFBBF7D0);

  static const Color infoBlue = Color(0xFF185E5E);
  static const Color infoBg = Color(0xFFE8F3F3);
  static const Color infoBorder = Color(0xFFBCE0E0);
}

/// Centralized typographic styles adhering to clear visual hierarchy.
class AppTextStyles {
  // Page Title: Large but not oversized
  static const TextStyle pageTitle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  // Section Title: Medium weight, clean
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.2,
  );

  // Card Title: Medium/bold
  static const TextStyle cardTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.1,
  );

  // Body text: Highly readable
  static const TextStyle body = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Supporting text: Smaller and muted
  static const TextStyle supporting = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
    height: 1.35,
  );

  // Metadata: Small and subtle
  static const TextStyle metadata = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );
}

/// Spacing scale (4, 8, 12, 16, 20, 24, 32)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}

/// Centralized Material 3 Application Theme
class AppTheme {
  // Expose colors for backward-compatibility with existing code
  static const Color primaryNavy = AppColors.primaryNavy;
  static const Color primaryNavyDark = AppColors.primaryNavyDark;
  static const Color primaryNavyLight = AppColors.primaryNavyLight;
  static const Color accentGreen = AppColors.secondaryTeal;
  static const Color accentGreenLight = AppColors.secondaryContainer;
  static const Color accentAmber = AppColors.warningAmber;
  static const Color accentAmberLight = AppColors.warningBg;
  static const Color accentBlue = AppColors.infoBlue;
  static const Color accentBlueLight = AppColors.infoBg;
  static const Color backgroundLight = AppColors.background;
  static const Color surfaceWhite = AppColors.surfaceWhite;
  static const Color surfaceMuted = AppColors.surfaceMuted;
  static const Color borderSubtle = AppColors.borderSubtle;
  static const Color borderMedium = AppColors.borderMedium;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textMuted = AppColors.textMuted;
  static const Color statusSubmitted = AppColors.statusSubmitted;
  static const Color statusUnderReview = AppColors.statusUnderReview;
  static const Color statusInProgress = AppColors.statusInProgress;
  static const Color statusResolved = AppColors.statusResolved;
  static const Color statusClosed = AppColors.statusClosed;

  // Very subtle shadow for cards (avoids exaggerated floating look)
  static List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryNavy,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.primaryNavyDark,
        secondary: AppColors.secondaryTeal,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.secondaryDark,
        error: AppColors.errorRed,
        onError: Colors.white,
        errorContainer: AppColors.errorBg,
        onErrorContainer: AppColors.errorRed,
        surface: AppColors.surfaceWhite,
        onSurface: AppColors.textPrimary,
        outline: AppColors.borderSubtle,
        outlineVariant: AppColors.borderMedium,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',

      // Standardized AppBars across the application
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceWhite,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryNavy, size: 22),
      ),

      // Standardized Card Theme with 12px radius and 1px subtle border
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),

      // Standardized Input Decoration for form fields & search
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        labelStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        errorStyle: const TextStyle(fontSize: 11, color: AppColors.errorRed),
      ),

      // Primary Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Secondary / Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          elevation: 0,
          minimumSize: const Size(0, 42),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          side: const BorderSide(color: AppColors.primaryNavy, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Material 3 Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceWhite,
        elevation: 0,
        height: 64,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            );
          }
          return const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryNavy, size: 22);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 22);
        }),
      ),

      // FilterChip & ChoiceChip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceMuted,
        selectedColor: AppColors.primaryContainer,
        secondarySelectedColor: AppColors.primaryNavy,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1,
        space: 1,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

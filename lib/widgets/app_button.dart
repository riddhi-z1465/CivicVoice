import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
export 'primary_button.dart';

enum AppButtonVariant { primary, secondary, outline, danger }

/// Reusable AppButton adhering strictly to the CivicVoice design system
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final AppButtonVariant variant;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.variant = AppButtonVariant.primary,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide? borderSide;

    switch (variant) {
      case AppButtonVariant.primary:
        bg = AppColors.primaryNavy;
        fg = Colors.white;
        borderSide = null;
        break;
      case AppButtonVariant.secondary:
        bg = AppColors.secondaryTeal;
        fg = Colors.white;
        borderSide = null;
        break;
      case AppButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.primaryNavy;
        borderSide = const BorderSide(color: AppColors.borderMedium);
        break;
      case AppButtonVariant.danger:
        bg = AppColors.errorRed;
        fg = Colors.white;
        borderSide = null;
        break;
    }

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.button.copyWith(color: fg)),
        ],
      );
    } else {
      child = Text(label, style: AppTextStyles.button.copyWith(color: fg));
    }

    Widget button;
    if (variant == AppButtonVariant.outline) {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: borderSide,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: child,
      );
    } else {
      button = FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: child,
      );
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Primary action button for CivicVoice with built-in loading state
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild;
    if (isLoading) {
      buttonChild = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.button),
        ],
      );
    } else {
      buttonChild = Text(label, style: AppTextStyles.button);
    }

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
        minimumSize: const Size(0, 46),
      ),
      child: buttonChild,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

/// Secondary / Outlined action button for CivicVoice
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild;
    if (icon != null) {
      buttonChild = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(label, style: AppTextStyles.button.copyWith(color: AppColors.primaryNavy)),
        ],
      );
    } else {
      buttonChild = Text(label, style: AppTextStyles.button.copyWith(color: AppColors.primaryNavy));
    }

    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
        minimumSize: const Size(0, 42),
      ),
      child: buttonChild,
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}

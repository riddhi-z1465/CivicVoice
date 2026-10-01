import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable civic surface card adhering to project design constraints:
/// - 1px subtle border
/// - 12-14px corner radius
/// - Soft ambient shadow for depth
/// - Natural spacing without floating neon or exaggerated effects
class CivicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Border? border;
  final double borderRadius;
  final bool hasShadow;

  const CivicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
    this.border,
    this.borderRadius = 12.0,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardDecoration = BoxDecoration(
      color: backgroundColor ?? AppColors.surfaceWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(color: AppColors.borderSubtle, width: 1),
      boxShadow: hasShadow ? AppTheme.subtleShadow : null,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            padding: padding,
            decoration: cardDecoration,
            child: child,
          ),
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: cardDecoration,
      child: child,
    );
  }
}

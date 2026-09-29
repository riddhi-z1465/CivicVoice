import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum BannerType { info, sampleData, officialSource, warning }

/// Clean, non-intrusive civic advisory banner
class InfoBanner extends StatelessWidget {
  final String text;
  final BannerType type;
  final VoidCallback? onAction;
  final String? actionLabel;

  const InfoBanner({
    super.key,
    required this.text,
    this.type = BannerType.info,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color iconColor;
    IconData icon;

    switch (type) {
      case BannerType.officialSource:
        bg = const Color(0xFFF0FDF4); // Subtle green
        border = const Color(0xFFBBF7D0);
        iconColor = AppTheme.accentGreen;
        icon = Icons.verified_user_outlined;
        break;
      case BannerType.sampleData:
        bg = const Color(0xFFFFFBEB); // Soft yellow/amber
        border = const Color(0xFFFDE68A);
        iconColor = AppTheme.accentAmber;
        icon = Icons.info_outline;
        break;
      case BannerType.warning:
        bg = const Color(0xFFFEF2F2);
        border = const Color(0xFFFECACA);
        iconColor = const Color(0xFFDC2626);
        icon = Icons.warning_amber_rounded;
        break;
      case BannerType.info:
        bg = const Color(0xFFEFF6FF); // Soft blue
        border = const Color(0xFFBFDBFE);
        iconColor = const Color(0xFF1D4ED8);
        icon = Icons.help_outline_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textPrimary,
                    height: 1.35,
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: iconColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

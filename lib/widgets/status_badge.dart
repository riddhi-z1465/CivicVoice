import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Clean, accessible badge showing the state of a civic issue report
/// Uses text + icon combination and restrained civic colors for full accessibility.
class StatusBadge extends StatelessWidget {
  final String status;
  final bool compact;

  const StatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'submitted':
        bg = AppColors.statusSubmittedBg;
        text = AppColors.statusSubmitted;
        border = AppColors.statusSubmittedBorder;
        icon = Icons.outbox_rounded;
        break;
      case 'under review':
        bg = AppColors.statusUnderReviewBg;
        text = AppColors.statusUnderReview;
        border = AppColors.statusUnderReviewBorder;
        icon = Icons.pending_actions_rounded;
        break;
      case 'in progress':
        bg = AppColors.statusInProgressBg;
        text = AppColors.statusInProgress;
        border = AppColors.statusInProgressBorder;
        icon = Icons.engineering_rounded;
        break;
      case 'resolved':
        bg = AppColors.statusResolvedBg;
        text = AppColors.statusResolved;
        border = AppColors.statusResolvedBorder;
        icon = Icons.check_circle_outline_rounded;
        break;
      case 'closed':
      default:
        bg = AppColors.statusClosedBg;
        text = AppColors.statusClosed;
        border = AppColors.statusClosedBorder;
        icon = Icons.archive_outlined;
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: text),
            const SizedBox(width: 4),
            Text(
              status,
              style: TextStyle(
                color: text,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: text),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: text,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Backward compatibility alias
typedef StatusChip = StatusBadge;

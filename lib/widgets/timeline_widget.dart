import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Clean, vertical status presentation with step dots & connectors:
/// ● Submitted
/// │
/// ● Under Review
/// │
/// ○ In Progress
/// │
/// ○ Resolved
class ReportTimelineWidget extends StatelessWidget {
  final List<ReportStatusLog> history;
  final String currentStatus;

  const ReportTimelineWidget({
    super.key,
    required this.history,
    required this.currentStatus,
  });

  static const List<String> standardStages = [
    'Submitted',
    'Under Review',
    'In Progress',
    'Resolved',
  ];

  int _getStageIndex(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 0;
      case 'under review':
        return 1;
      case 'in progress':
        return 2;
      case 'resolved':
      case 'closed':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _getStageIndex(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vertical Step Timeline
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
          child: Column(
            children: List.generate(standardStages.length, (index) {
              final stage = standardStages[index];
              final isCompleted = index < activeIndex;
              final isCurrent = index == activeIndex;
              final isReached = index <= activeIndex;
              final isLast = index == standardStages.length - 1;

              // Find timestamp if reached
              String? stageTime;
              for (final log in history) {
                if (log.status.toLowerCase() == stage.toLowerCase()) {
                  stageTime = Formatters.formatDateTime(log.timestamp);
                  break;
                }
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dot and vertical connector
                  Column(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isReached ? AppColors.secondaryTeal : Colors.white,
                          border: Border.all(
                            color: isReached ? AppColors.secondaryTeal : AppColors.borderMedium,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, size: 11, color: Colors.white)
                              : isCurrent
                                  ? Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 28,
                          color: isCompleted ? AppColors.secondaryTeal : AppColors.borderSubtle,
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.md),

                  // Stage Label & Status
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stage,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isCurrent
                                      ? FontWeight.w700
                                      : (isReached ? FontWeight.w600 : FontWeight.normal),
                                  color: isReached ? AppColors.textPrimary : AppColors.textMuted,
                                ),
                              ),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'CURRENT STAGE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondaryDark,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (stageTime != null) ...[
                            const SizedBox(height: 1),
                            Text(
                              stageTime,
                              style: AppTextStyles.metadata,
                            ),
                          ],
                          if (!isLast) const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.md),

        // Status History & Officer Remarks
        const Text(
          'Official History & Remarks',
          style: AppTextStyles.cardTitle,
        ),
        const SizedBox(height: AppSpacing.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final log = history[history.length - 1 - index]; // latest first
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        log.status,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      Text(
                        Formatters.formatDateTime(log.timestamp),
                        style: AppTextStyles.metadata,
                      ),
                    ],
                  ),
                  if (log.remarks.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      log.remarks,
                      style: AppTextStyles.supporting.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Clean, simple lifecycle timeline for civic issue tracking
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
        // Horizontal progress step indicator
        Row(
          children: List.generate(standardStages.length * 2 - 1, (index) {
            if (index.isOdd) {
              // Connector Line
              final stepBefore = index ~/ 2;
              final isPassed = stepBefore < activeIndex;
              return Expanded(
                child: Container(
                  height: 2,
                  color: isPassed ? AppTheme.accentGreen : AppTheme.borderSubtle,
                ),
              );
            } else {
              // Step Dot
              final stepIndex = index ~/ 2;
              final isReached = stepIndex <= activeIndex;

              return Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isReached ? AppTheme.accentGreen : Colors.white,
                  border: Border.all(
                    color: isReached ? AppTheme.accentGreen : AppTheme.borderMedium,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isReached
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '${stepIndex + 1}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMuted,
                          ),
                        ),
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),

        // Stage labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: standardStages.map((stage) {
            final isReached = _getStageIndex(stage) <= activeIndex;
            return Expanded(
              child: Text(
                stage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isReached ? FontWeight.w600 : FontWeight.normal,
                  color: isReached ? AppTheme.textPrimary : AppTheme.textMuted,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Detailed audit log entries
        const Text(
          'Status History & Officer Remarks',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final log = history[history.length - 1 - index]; // latest first
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.borderSubtle),
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
                          color: AppTheme.primaryNavy,
                        ),
                      ),
                      Text(
                        Formatters.formatDateTime(log.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  if (log.remarks.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      log.remarks,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
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

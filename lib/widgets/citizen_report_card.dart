import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'status_badge.dart';

/// Standard Citizen Report Card adhering to public service utility design:
/// Shows title, category, date, and current status badge.
class CitizenReportCard extends StatelessWidget {
  final CivicReport report;
  final VoidCallback onTap;

  const CitizenReportCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'street light':
        return Icons.lightbulb_outline;
      case 'road':
        return Icons.add_road_outlined;
      case 'garbage':
        return Icons.delete_outline;
      case 'water supply':
        return Icons.water_drop_outlined;
      case 'public safety':
        return Icons.security_outlined;
      case 'drainage':
        return Icons.waves_outlined;
      case 'traffic':
        return Icons.traffic_outlined;
      default:
        return Icons.report_problem_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _getCategoryIcon(report.category),
                      size: 16,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm + 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: AppTextStyles.cardTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          report.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (report.location.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textMuted),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  report.location,
                                  style: AppTextStyles.metadata,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.formatDate(report.createdAt),
                        style: AppTextStyles.metadata,
                      ),
                    ],
                  ),
                  StatusBadge(status: report.status, compact: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

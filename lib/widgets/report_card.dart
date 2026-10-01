import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'civic_card.dart';
import 'status_badge.dart';

/// Standardized Report Card adhering to civic utility guidelines:
/// [Title]
/// [Category / Location]
/// [Date]                       [StatusBadge]
class ReportCard extends StatelessWidget {
  final CivicReport report;
  final VoidCallback onTap;

  const ReportCard({
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
    return CivicCard(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      onTap: onTap,
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
                      '${report.category} • ${report.location}',
                      style: AppTextStyles.supporting,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatters.formatDate(report.createdAt),
                style: AppTextStyles.metadata,
              ),
              StatusBadge(status: report.status, compact: true),
            ],
          ),
        ],
      ),
    );
  }
}

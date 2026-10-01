import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'status_badge.dart';

/// Operational Report Card for Civic Authorities / Administrators
/// Displays Report ID, Category, Location, Date, Status, and View action button
class AdminReportCard extends StatelessWidget {
  final CivicReport report;
  final VoidCallback onView;

  const AdminReportCard({
    super.key,
    required this.report,
    required this.onView,
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onView,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Report ID & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        report.id,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNavy,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    StatusBadge(status: report.status, compact: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title & Category
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            report.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Metadata: Location & Date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                report.location.isNotEmpty ? report.location : 'Ward 12',
                                style: AppTextStyles.metadata.copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
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
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm + 2),

                // Bottom action row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${report.statusHistory.length} status ${report.statusHistory.length == 1 ? 'update' : 'updates'}',
                      style: AppTextStyles.metadata,
                    ),
                    FilledButton.tonal(
                      onPressed: onView,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: AppColors.primaryNavy.withValues(alpha: 0.08),
                        foregroundColor: AppColors.primaryNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Review',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward, size: 13),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/civic_report.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/location_map_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/timeline_widget.dart';

/// Citizen View of Report Details
/// Strictly read-only for citizens — displays Report ID, Issue, Description,
/// Location, Evidence Image, Submitted Date, and Status Timeline.
/// Citizens cannot modify administrative status.
class ReportDetailScreen extends StatelessWidget {
  final CivicReport report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(report.id),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: StatusBadge(status: report.status, compact: true),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Header Card
              Container(
                width: double.infinity,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          report.id,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavy,
                            letterSpacing: 0.3,
                          ),
                        ),
                        StatusBadge(status: report.status, compact: true),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      report.category,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTeal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Divider(height: 1),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            report.location,
                            style: AppTextStyles.supporting,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Submitted on ${Formatters.formatDateTime(report.createdAt)}',
                          style: AppTextStyles.metadata,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Resolution Progress Timeline (Step dots: Submitted -> Under Review -> In Progress -> Resolved)
              const SectionHeader(
                title: 'Status Timeline',
                subtitle: 'Live municipal lifecycle progression',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: ReportTimelineWidget(
                  history: report.statusHistory,
                  currentStatus: report.status,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Issue Description
              const SectionHeader(
                title: 'Issue Description',
                subtitle: 'Submitted grievance summary',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  report.description.isNotEmpty
                      ? report.description
                      : 'No additional description provided.',
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Incident Location & Mapping
              const SectionHeader(
                title: 'Location Details',
                subtitle: 'Registered site of issue',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.errorRed),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            report.location,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LocationMapWidget(
                      latitude: report.latitude ?? 19.0760,
                      longitude: report.longitude ?? 72.8777,
                      locationName: report.location,
                      height: 150,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Evidence Photo
              const SectionHeader(
                title: 'Evidence',
                subtitle: 'Attached photo documentation',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: _buildEvidence(report.imageUrl),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvidence(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _evidencePlaceholder(),
          ),
        );
      } else if (!kIsWeb) {
        final f = File(imageUrl);
        if (f.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              f,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        }
      }
    }
    return _evidencePlaceholder();
  }

  Widget _evidencePlaceholder() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 24, color: AppColors.textMuted),
            SizedBox(height: 4),
            Text('No image attached to this report', style: AppTextStyles.metadata),
          ],
        ),
      ),
    );
  }
}

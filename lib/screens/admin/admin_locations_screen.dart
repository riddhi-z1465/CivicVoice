import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/civic_report.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/location_map_widget.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';
import 'admin_report_detail_screen.dart';

class AdminLocationsScreen extends StatefulWidget {
  const AdminLocationsScreen({super.key});

  @override
  State<AdminLocationsScreen> createState() => _AdminLocationsScreenState();
}

class _AdminLocationsScreenState extends State<AdminLocationsScreen> {
  String _selectedStatusFilter = 'All';
  CivicReport? _selectedReport;

  @override
  Widget build(BuildContext context) {
    final reportProv = Provider.of<ReportProvider>(context);
    final allReports = reportProv.allReports;

    final filteredReports = _selectedStatusFilter == 'All'
        ? allReports
        : allReports.where((r) => r.status.toLowerCase() == _selectedStatusFilter.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Issue Locations & Geo-Mapping'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Interactive Map View
            SizedBox(
              height: 240,
              child: LocationMapWidget(
                latitude: _selectedReport?.latitude ?? 19.0760,
                longitude: _selectedReport?.longitude ?? 72.8777,
                locationName: _selectedReport?.location ?? 'Ward 12 Municipal Grid',
                reports: filteredReports,
                selectedReport: _selectedReport,
                onSelectReport: (report) {
                  setState(() {
                    _selectedReport = report;
                  });
                },
                height: 240,
              ),
            ),

            // Filter Chips Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: AppColors.surfaceWhite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Submitted', 'Under Review', 'In Progress', 'Resolved'].map((status) {
                    final isSelected = _selectedStatusFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: isSelected,
                        labelStyle: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                        selectedColor: AppColors.primaryNavy,
                        backgroundColor: AppColors.surfaceMuted,
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryNavy : AppColors.borderSubtle,
                        ),
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedStatusFilter = status;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1),

            // List of Reports by Location
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeader(
                    title: 'Reports by Location & Ward',
                    subtitle: 'Select any grievance to highlight location or view details',
                  ),
                  Text(
                    '${filteredReports.length} found',
                    style: AppTextStyles.metadata,
                  ),
                ],
              ),
            ),

            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(
                      child: Text(
                        'No issues found for this filter.',
                        style: AppTextStyles.supporting,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                      itemCount: filteredReports.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final report = filteredReports[index];
                        final isSelected = _selectedReport?.id == report.id;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedReport = report;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.5) : AppColors.surfaceWhite,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryNavy : AppColors.borderSubtle,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(report.status),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report.title,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                report.location.isNotEmpty ? report.location : 'Ward Sector',
                                                style: AppTextStyles.metadata,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      StatusBadge(status: report.status, compact: true),
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AdminReportDetailScreen(report: report),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Details →',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryNavy,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return AppColors.statusSubmitted;
      case 'under review':
        return AppColors.statusUnderReview;
      case 'in progress':
        return AppColors.statusInProgress;
      case 'resolved':
        return AppColors.statusResolved;
      default:
        return AppColors.statusClosed;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/civic_report.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/civic_card.dart';
import '../../widgets/status_chip.dart';
import 'report_detail_screen.dart';
import 'report_issue_screen.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

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
    final reportProv = Provider.of<ReportProvider>(context);

    final totalCount = reportProv.allReports.length;
    final activeCount = reportProv.allReports
        .where((r) => r.status != 'Resolved' && r.status != 'Closed')
        .length;
    final resolvedCount = reportProv.allReports
        .where((r) => r.status == 'Resolved' || r.status == 'Closed')
        .length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('My Civic Reports'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
          );
        },
        backgroundColor: AppTheme.primaryNavy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Report Issue', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Grievance Summary Counters Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              color: AppTheme.surfaceWhite,
              child: Row(
                children: [
                  _summaryPill(label: 'Total', count: totalCount, color: AppTheme.primaryNavy),
                  const SizedBox(width: 8),
                  _summaryPill(label: 'Active', count: activeCount, color: const Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  _summaryPill(label: 'Resolved', count: resolvedCount, color: AppTheme.accentGreen),
                ],
              ),
            ),
            const Divider(height: 1),

            // Filter Chips Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: AppTheme.surfaceWhite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'All Reports',
                      isSelected: reportProv.selectedStatusFilter == 'All',
                      onSelected: () => reportProv.setStatusFilter('All'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Active Issues',
                      isSelected: reportProv.selectedStatusFilter == 'Active',
                      onSelected: () => reportProv.setStatusFilter('Active'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Submitted',
                      isSelected: reportProv.selectedStatusFilter == 'Submitted',
                      onSelected: () => reportProv.setStatusFilter('Submitted'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'In Progress',
                      isSelected: reportProv.selectedStatusFilter == 'In Progress',
                      onSelected: () => reportProv.setStatusFilter('In Progress'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Resolved',
                      isSelected: reportProv.selectedStatusFilter == 'Resolved',
                      onSelected: () => reportProv.setStatusFilter('Resolved'),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),

            // Reports List or Empty State
            Expanded(
              child: reportProv.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => reportProv.loadReports(),
                      child: reportProv.reports.isEmpty
                          ? Center(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.assignment_turned_in_outlined, size: 48, color: AppTheme.textMuted),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'No reports found.',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'There are no civic grievances matching the selected filter criteria.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                    const SizedBox(height: 16),
                                    OutlinedButton(
                                      onPressed: () => reportProv.setStatusFilter('All'),
                                      child: const Text('Show All Reports'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                              itemCount: reportProv.reports.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final report = reportProv.reports[index];
                                return _buildReportCard(context, report);
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryPill({required String label, required int count, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      backgroundColor: AppTheme.surfaceMuted,
      selectedColor: AppTheme.primaryNavy,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppTheme.textSecondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryNavy : AppTheme.borderSubtle,
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, CivicReport report) {
    return CivicCard(
      padding: const EdgeInsets.all(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReportDetailScreen(report: report)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Category Icon + Title snippet + Status Chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(_getCategoryIcon(report.category), size: 18, color: AppTheme.primaryNavy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          report.id,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryNavy),
                        ),
                        StatusChip(status: report.status, compact: true),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: AppTheme.textMuted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            report.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Bottom: Date and arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Logged on ${Formatters.formatDate(report.createdAt)}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
              const Row(
                children: [
                  Text('Track Resolution', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryNavy)),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right, size: 16, color: AppTheme.primaryNavy),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

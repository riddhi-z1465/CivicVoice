import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/citizen_report_card.dart';
import '../../widgets/empty_state.dart';
import 'report_detail_screen.dart';
import 'report_issue_screen.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final reportProv = Provider.of<ReportProvider>(context);
    final citizenId = auth.user?.uid;

    final allMyReports = reportProv.getCitizenReports(citizenId, statusFilter: 'All');
    final filteredMyReports = reportProv.getCitizenReports(citizenId);

    final totalCount = allMyReports.length;
    final activeCount = allMyReports
        .where((r) => r.status != 'Resolved' && r.status != 'Closed')
        .length;
    final resolvedCount = allMyReports
        .where((r) => r.status == 'Resolved' || r.status == 'Closed')
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Reports'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
          );
        },
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Report an Issue', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Grievance Summary Counters Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: AppColors.surfaceWhite,
              child: Row(
                children: [
                  _summaryPill(label: 'Total', count: totalCount, color: AppColors.primaryNavy),
                  const SizedBox(width: AppSpacing.sm),
                  _summaryPill(label: 'Active', count: activeCount, color: AppColors.warningAmber),
                  const SizedBox(width: AppSpacing.sm),
                  _summaryPill(label: 'Resolved', count: resolvedCount, color: AppColors.secondaryTeal),
                ],
              ),
            ),
            const Divider(height: 1),

            // Filter Chips Bar (All | Submitted | Under Review | In Progress | Resolved)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: AppColors.surfaceWhite,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'All',
                      isSelected: reportProv.selectedStatusFilter == 'All',
                      onSelected: () => reportProv.setStatusFilter('All'),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    _buildFilterChip(
                      label: 'Submitted',
                      isSelected: reportProv.selectedStatusFilter == 'Submitted',
                      onSelected: () => reportProv.setStatusFilter('Submitted'),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    _buildFilterChip(
                      label: 'Under Review',
                      isSelected: reportProv.selectedStatusFilter == 'Under Review',
                      onSelected: () => reportProv.setStatusFilter('Under Review'),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    _buildFilterChip(
                      label: 'In Progress',
                      isSelected: reportProv.selectedStatusFilter == 'In Progress',
                      onSelected: () => reportProv.setStatusFilter('In Progress'),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
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
                      child: filteredMyReports.isEmpty
                          ? ListView(
                              children: [
                                const SizedBox(height: AppSpacing.xxl),
                                EmptyState(
                                  icon: Icons.assignment_outlined,
                                  title: 'No reports yet',
                                  description: 'Reports you submit will appear here.',
                                  actionLabel: 'Report an Issue',
                                  onAction: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
                                    );
                                  },
                                ),
                              ],
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 84),
                              itemCount: filteredMyReports.length,
                              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm + 2),
                              itemBuilder: (context, index) {
                                final report = filteredMyReports[index];
                                return CitizenReportCard(
                                  report: report,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => ReportDetailScreen(report: report)),
                                    );
                                  },
                                );
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
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            '$label: $count',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
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
      backgroundColor: AppColors.surfaceMuted,
      selectedColor: AppColors.primaryContainer,
      labelStyle: TextStyle(
        fontSize: 11.5,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? AppColors.primaryNavy : AppColors.textSecondary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: isSelected ? AppColors.borderMedium : AppColors.borderSubtle,
        ),
      ),
    );
  }
}

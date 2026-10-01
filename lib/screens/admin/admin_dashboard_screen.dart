import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/admin_report_card.dart';
import '../../widgets/civic_logo.dart';
import '../../widgets/section_header.dart';
import '../../widgets/stat_card.dart';
import 'admin_report_detail_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const AdminDashboardScreen({super.key, this.onNavigateTab});

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final reportProv = Provider.of<ReportProvider>(context);
    final officerName = auth.user?.name ?? 'Civic Authority Officer';
    final now = DateTime.now();

    // Urgent / pending reports needing review
    final pendingReports = reportProv.allReports
        .where((r) => r.status.toLowerCase() == 'submitted' || r.status.toLowerCase() == 'under review')
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const CivicLogo(size: 32),
            const SizedBox(width: AppSpacing.sm + 2),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CivicVoice Authority',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(
                  'Municipal Administration Console',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (onNavigateTab != null) {
                  onNavigateTab!(3); // Switch to Profile tab
                }
              },
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Center(
                  child: Text(
                    officerName.isNotEmpty ? officerName[0].toUpperCase() : 'A',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => reportProv.loadReports(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getTimeGreeting()}, $officerName',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryNavy,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Monitor and manage civic reports submitted by citizens.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryNavy,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('hh:mm a').format(now),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryNavy,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('EEEE, d MMMM yyyy').format(now),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Statistics Section (Compact, restrained cards)
                const SectionHeader(
                  title: 'Operational Overview',
                  subtitle: 'Live municipal issue resolution status across all sectors',
                ),
                const SizedBox(height: AppSpacing.xs),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;
                    return GridView.count(
                      crossAxisCount: isTablet ? 4 : 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: isTablet ? 1.6 : 1.45,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        StatCard(
                          title: 'Total Reports',
                          value: '${reportProv.totalCount}',
                          icon: Icons.assignment_outlined,
                          accentColor: AppColors.primaryNavy,
                          subtitle: 'Registered grievances',
                          onTap: () {
                            if (onNavigateTab != null) onNavigateTab!(1);
                          },
                        ),
                        StatCard(
                          title: 'Pending Review',
                          value: '${reportProv.pendingReviewCount}',
                          icon: Icons.pending_actions_rounded,
                          accentColor: AppColors.warningAmber,
                          subtitle: 'Require initial audit',
                          onTap: () {
                            reportProv.setAdminStatusFilter('Pending');
                            if (onNavigateTab != null) onNavigateTab!(1);
                          },
                        ),
                        StatCard(
                          title: 'In Progress',
                          value: '${reportProv.inProgressCount}',
                          icon: Icons.engineering_rounded,
                          accentColor: AppColors.statusInProgress,
                          subtitle: 'Assigned to field staff',
                          onTap: () {
                            reportProv.setAdminStatusFilter('In Progress');
                            if (onNavigateTab != null) onNavigateTab!(1);
                          },
                        ),
                        StatCard(
                          title: 'Resolved',
                          value: '${reportProv.resolvedCount}',
                          icon: Icons.check_circle_outline_rounded,
                          accentColor: AppColors.secondaryTeal,
                          subtitle: 'Completed & verified',
                          onTap: () {
                            reportProv.setAdminStatusFilter('Resolved');
                            if (onNavigateTab != null) onNavigateTab!(1);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Action Shortcuts Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 2, vertical: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (onNavigateTab != null) onNavigateTab!(1); // Reports tab
                          },
                          icon: const Icon(Icons.filter_list, size: 16),
                          label: const Text('Filter Reports', style: TextStyle(fontSize: 12.5)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryNavy,
                            side: const BorderSide(color: AppColors.borderSubtle),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (onNavigateTab != null) onNavigateTab!(2); // Map tab
                          },
                          icon: const Icon(Icons.map_outlined, size: 16),
                          label: const Text('View Geo-Map', style: TextStyle(fontSize: 12.5)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryNavy,
                            side: const BorderSide(color: AppColors.borderSubtle),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Incoming & Pending Review Reports Section
                SectionHeader(
                  title: 'Incoming Reports Requiring Action',
                  subtitle: 'Citizens waiting for initial review or assignment',
                  actionLabel: 'View All (${reportProv.totalCount})',
                  onAction: () {
                    if (onNavigateTab != null) onNavigateTab!(1);
                  },
                ),
                const SizedBox(height: AppSpacing.xs),

                if (pendingReports.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.done_all, size: 32, color: AppColors.secondaryTeal),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            'All incoming reports reviewed',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'No citizen reports are currently pending initial verification.',
                            style: AppTextStyles.supporting,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingReports.take(3).length,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm + 2),
                    itemBuilder: (context, index) {
                      final report = pendingReports[index];
                      return AdminReportCard(
                        report: report,
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminReportDetailScreen(report: report),
                            ),
                          );
                        },
                      );
                    },
                  ),
                const SizedBox(height: AppSpacing.xxl),

                // Category Distribution Overview
                const SectionHeader(
                  title: 'Issue Distribution by Category',
                  subtitle: 'Aggregated citizen reports per municipal department',
                ),
                const SizedBox(height: AppSpacing.xs),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                    boxShadow: AppTheme.subtleShadow,
                  ),
                  child: Column(
                    children: reportProv.categoryCounts.entries.map((entry) {
                      final total = reportProv.totalCount > 0 ? reportProv.totalCount : 1;
                      final percent = (entry.value / total);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                                Text(
                                  '${entry.value} reports (${(percent * 100).toStringAsFixed(0)}%)',
                                  style: AppTextStyles.metadata,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            LinearProgressIndicator(
                              value: percent,
                              minHeight: 5,
                              backgroundColor: AppColors.surfaceMuted,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryNavy),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

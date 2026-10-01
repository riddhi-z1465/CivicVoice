import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../widgets/admin_report_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/search_field.dart';
import 'admin_report_detail_screen.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _statusOptions = [
    'All',
    'Submitted',
    'Under Review',
    'In Progress',
    'Resolved',
    'Closed',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCategoryFilterSheet(BuildContext context, ReportProvider reportProv) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                  child: Text(
                    'Filter by Grievance Category',
                    style: AppTextStyles.sectionTitle,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Divider(),
                ListTile(
                  title: const Text('All Categories', style: TextStyle(fontSize: 13)),
                  trailing: reportProv.adminCategoryFilter == 'All'
                      ? const Icon(Icons.check, size: 18, color: AppColors.primaryNavy)
                      : null,
                  onTap: () {
                    reportProv.setAdminCategoryFilter('All');
                    Navigator.pop(ctx);
                  },
                ),
                ...AppConstants.issueCategories.map((cat) {
                  final isSelected = reportProv.adminCategoryFilter == cat;
                  return ListTile(
                    title: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primaryNavy : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, size: 18, color: AppColors.primaryNavy)
                        : null,
                    onTap: () {
                      reportProv.setAdminCategoryFilter(cat);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportProv = Provider.of<ReportProvider>(context);
    final reports = reportProv.adminReports;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Municipal Grievance Register'),
        actions: [
          IconButton(
            icon: Icon(
              reportProv.adminSortOrder == 'newest' ? Icons.south_rounded : Icons.north_rounded,
              size: 20,
            ),
            tooltip: reportProv.adminSortOrder == 'newest' ? 'Sorted: Newest First' : 'Sorted: Oldest First',
            onPressed: () {
              reportProv.setAdminSortOrder(
                reportProv.adminSortOrder == 'newest' ? 'oldest' : 'newest',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Refresh reports from Firestore',
            onPressed: () => reportProv.loadReports(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Controls Container
            Container(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
              color: AppColors.surfaceWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CivicSearchField(
                    controller: _searchController,
                    hintText: 'Search by Report ID, title, keyword or area...',
                    onChanged: (val) => reportProv.setAdminSearchQuery(val),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Filter Row (Category dropdown button + Clear action)
                  Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.category_outlined, size: 14, color: AppColors.primaryNavy),
                        label: Text(
                          reportProv.adminCategoryFilter == 'All'
                              ? 'Category: All'
                              : reportProv.adminCategoryFilter,
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: reportProv.adminCategoryFilter != 'All'
                            ? AppColors.primaryContainer
                            : AppColors.surfaceMuted,
                        side: const BorderSide(color: AppColors.borderSubtle),
                        onPressed: () => _showCategoryFilterSheet(context, reportProv),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      if (reportProv.adminSearchQuery.isNotEmpty ||
                          reportProv.adminStatusFilter != 'All' ||
                          reportProv.adminCategoryFilter != 'All')
                        TextButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            reportProv.clearAdminFilters();
                          },
                          icon: const Icon(Icons.close, size: 14),
                          label: const Text('Clear Filters', style: TextStyle(fontSize: 11.5)),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.errorRed,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      const Spacer(),
                      Text(
                        '${reports.length} ${reports.length == 1 ? 'report' : 'reports'}',
                        style: AppTextStyles.metadata,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Horizontal Status Filter Chips Bar
            Container(
              color: AppColors.surfaceWhite,
              padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, bottom: AppSpacing.sm),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _statusOptions.map((status) {
                    final isSelected = reportProv.adminStatusFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
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
                          if (val) reportProv.setAdminStatusFilter(status);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(height: 1),

            // Main Reports List View
            Expanded(
              child: reports.isEmpty
                  ? EmptyState(
                      title: 'No reports found',
                      description: 'No civic grievances match the specified search query or status filters.',
                      icon: Icons.search_off_rounded,
                      actionLabel: 'Reset Filters',
                      onAction: () {
                        _searchController.clear();
                        reportProv.clearAdminFilters();
                      },
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: reports.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final report = reports[index];
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
            ),
          ],
        ),
      ),
    );
  }
}

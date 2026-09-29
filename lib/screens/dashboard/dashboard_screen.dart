import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/civic_report.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/civic_card.dart';
import '../../widgets/status_chip.dart';
import '../voter_info/voter_info_screen.dart';
import '../candidates/candidate_list_screen.dart';
import '../polling_booths/polling_booth_screen.dart';
import '../reports/report_issue_screen.dart';
import '../reports/report_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  final ValueChanged<int>? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

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
    final auth = Provider.of<AuthProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);
    final userName = auth.user?.name ?? 'Citizen';
    final userWard = auth.user?.constituency ?? 'North Central Ward 12';

    // Calculate active grievance count
    final activeCount = reportProvider.allReports
        .where((r) => r.status != 'Resolved' && r.status != 'Closed')
        .length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppTheme.primaryNavy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.how_to_vote, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CivicVoice',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  userWard,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            tooltip: 'Civic Notices',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ward Notification: Electoral list revision camp scheduled this Saturday at Municipal Hall.'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => reportProvider.loadReports(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Citizen Welcome Card
                CivicCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.accentGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Citizen Session Active',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.accentGreen,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceMuted,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: Text(
                              auth.user?.epicNumber ?? 'EPIC-904128',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${_getTimeGreeting()}, $userName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryNavy,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Stay informed. Stay involved.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Municipal Bulletin / Advisory Announcement
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.campaign_outlined, size: 20, color: AppTheme.accentGreen),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Municipal Bulletin: Special Electoral Revision',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Claims and objections for Form 6 & Form 8 address updates are accepted until Oct 15.',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.35),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick Ward Metrics Strip (Functional & Believable)
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        icon: Icons.assignment_outlined,
                        iconColor: const Color(0xFF0284C7),
                        title: 'Active Reports',
                        value: '$activeCount Open',
                        onTap: () {
                          if (onNavigateTab != null) onNavigateTab!(2);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricTile(
                        icon: Icons.how_to_vote_outlined,
                        iconColor: AppTheme.accentGreen,
                        title: 'Assigned Booth',
                        value: 'Booth 101',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PollingBoothScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricTile(
                        icon: Icons.verified_user_outlined,
                        iconColor: AppTheme.accentAmber,
                        title: 'Roll Status',
                        value: 'Enrolled',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VoterInfoScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Section Title: Civic Services
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Civic Services',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Ward 12 Roster',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Four Main Action Cards
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;
                    return GridView.count(
                      crossAxisCount: isTablet ? 4 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isTablet ? 1.35 : 0.95,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildActionCard(
                          context: context,
                          badge: 'ECI Services',
                          icon: Icons.how_to_reg_outlined,
                          iconBg: const Color(0xFFEFF6FF),
                          iconColor: const Color(0xFF1D4ED8),
                          title: 'Voter Information',
                          subtitle: 'Registration, Form 6/8 and eligibility',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const VoterInfoScreen()),
                            );
                          },
                        ),
                        _buildActionCard(
                          context: context,
                          badge: 'Affidavits',
                          icon: Icons.badge_outlined,
                          iconBg: const Color(0xFFF0FDF4),
                          iconColor: const Color(0xFF15803D),
                          title: 'Candidate Profiles',
                          subtitle: 'Public records, education and declared assets',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CandidateListScreen()),
                            );
                          },
                        ),
                        _buildActionCard(
                          context: context,
                          badge: 'Locations',
                          icon: Icons.where_to_vote_outlined,
                          iconBg: const Color(0xFFFFFBEB),
                          iconColor: const Color(0xFFB45309),
                          title: 'Polling Booths',
                          subtitle: 'Find nearby stations, distance & map route',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PollingBoothScreen()),
                            );
                          },
                        ),
                        _buildActionCard(
                          context: context,
                          badge: 'Municipal Grievance',
                          icon: Icons.report_problem_outlined,
                          iconBg: const Color(0xFFFEF2F2),
                          iconColor: const Color(0xFFDC2626),
                          title: 'Report an Issue',
                          subtitle: 'File street light, pothole or waste issue',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Section: Recent Reports
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Reports',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        if (onNavigateTab != null) {
                          onNavigateTab!(2);
                        }
                      },
                      icon: const Icon(Icons.arrow_forward, size: 13),
                      label: const Text('View All Reports', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (reportProvider.recentReports.isEmpty)
                  CivicCard(
                    padding: const EdgeInsets.all(22),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.assignment_outlined, size: 36, color: AppTheme.textMuted),
                          const SizedBox(height: 10),
                          const Text(
                            'No civic reports filed yet',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Encountered a pothole, broken streetlight or water leak? Submit a ticket to alert ward engineers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
                              );
                            },
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Report Issue', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reportProvider.recentReports.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final report = reportProvider.recentReports[index];
                      return _buildRecentReportTile(context, report);
                    },
                  ),
                const SizedBox(height: 22),

                // Citizen Helpline & Services Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderSubtle),
                    boxShadow: AppTheme.subtleShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.support_agent_outlined, size: 18, color: AppTheme.primaryNavy),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Official Citizen Hotlines',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Direct dial toll-free numbers for election queries and emergency municipal grievances:',
                        style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _helplinePill(
                              label: 'Voter Helpline: 1950',
                              subtext: 'ECI National',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _helplinePill(
                              label: 'Civic Grievance: 1913',
                              subtext: 'Municipal Ward',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return CivicCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String badge,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return CivicCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const Icon(Icons.arrow_forward_ios, size: 11, color: AppTheme.textMuted),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReportTile(BuildContext context, CivicReport report) {
    return CivicCard(
      padding: const EdgeInsets.all(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDetailScreen(report: report),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getCategoryIcon(report.category),
                  size: 18,
                  color: AppTheme.primaryNavy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.pin_drop_outlined, size: 12, color: AppTheme.textMuted),
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
              StatusChip(status: report.status, compact: true),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Submitted · ${Formatters.formatDate(report.createdAt)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
              Text(
                report.id,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _helplinePill({required String label, required String subtext}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primaryNavy),
          ),
          const SizedBox(height: 1),
          Text(
            subtext,
            style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }
}

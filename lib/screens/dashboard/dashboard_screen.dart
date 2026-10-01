import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/citizen_report_card.dart';
import '../../widgets/citizen_service_card.dart';
import '../../widgets/civic_card.dart';
import '../../widgets/civic_logo.dart';
import '../../widgets/section_header.dart';
import '../voter_info/voter_info_screen.dart';
import '../candidates/candidate_list_screen.dart';
import '../polling_booths/polling_booth_screen.dart';
import '../reports/report_issue_screen.dart';
import '../reports/report_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  final ValueChanged<int>? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    // Real-time periodic timer to ensure greeting, date, and clock update live
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getTimeGreeting() {
    final hour = _currentTime.hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good evening';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final reportProvider = Provider.of<ReportProvider>(context);
    final userName = auth.user?.name ?? 'Citizen';
    final userWard = auth.user?.constituency ?? 'North Central Ward 12';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const CivicLogo(size: 32),
            const SizedBox(width: AppSpacing.sm + 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CivicVoice',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(
                  userWard,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.normal),
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
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3); // Switch to Profile tab
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
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'C',
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
          onRefresh: () => reportProvider.loadReports(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Real-time Greeting & Live Indicator Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getTimeGreeting()}, $userName',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryNavy,
                              letterSpacing: -0.4,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Access civic information, find polling locations and report local issues.',
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
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.successBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.successGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('hh:mm a').format(_currentTime),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.successGreen,
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
                      DateFormat('EEEE, d MMMM yyyy').format(_currentTime),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // 3. Main Services (Four compact service actions matching Section 6)
                const SectionHeader(
                  title: 'Main Services',
                  subtitle: 'Direct access to electoral guidance and grievance reporting',
                ),
                const SizedBox(height: AppSpacing.xs),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isTablet = constraints.maxWidth > 600;
                    return GridView.count(
                      crossAxisCount: isTablet ? 4 : 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: isTablet ? 1.6 : 1.35,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CitizenServiceCard(
                          icon: Icons.how_to_reg_outlined,
                          title: 'Voter Information',
                          subtitle: 'Access registration and voter guidance',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const VoterInfoScreen()),
                            );
                          },
                        ),
                        CitizenServiceCard(
                          icon: Icons.badge_outlined,
                          title: 'Candidate Profiles',
                          subtitle: 'View publicly available information',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CandidateListScreen()),
                            );
                          },
                        ),
                        CitizenServiceCard(
                          icon: Icons.where_to_vote_outlined,
                          title: 'Polling Booths',
                          subtitle: 'Find nearby polling locations',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PollingBoothScreen()),
                            );
                          },
                        ),
                        CitizenServiceCard(
                          icon: Icons.report_problem_outlined,
                          title: 'Report an Issue',
                          subtitle: 'Report a problem in your area',
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
                const SizedBox(height: AppSpacing.xxl),

                // 4. Recent Reports Section (Scoped to the authenticated citizen)
                Builder(
                  builder: (context) {
                    final citizenReports = reportProvider.getCitizenRecentReports(auth.user?.uid);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Recent Reports',
                          subtitle: 'Status of your submitted civic grievances',
                          actionLabel: citizenReports.isNotEmpty ? 'View All' : null,
                          onAction: () {
                            if (widget.onNavigateTab != null) {
                              widget.onNavigateTab!(2); // Switch to Reports tab
                            }
                          },
                        ),
                        const SizedBox(height: AppSpacing.xs),

                        if (citizenReports.isEmpty)
                          CivicCard(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: AppColors.surfaceMuted,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.assignment_outlined, size: 22, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  const Text(
                                    'No reports yet',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Reports you submit will appear here.',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.supporting,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  FilledButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const ReportIssueScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.add, size: 15),
                                    label: const Text('Report an Issue', style: TextStyle(fontSize: 12)),
                                    style: FilledButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: citizenReports.take(3).length,
                            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm + 2),
                            itemBuilder: (context, index) {
                              final report = citizenReports[index];
                              return CitizenReportCard(
                                report: report,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReportDetailScreen(report: report),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),

                // 5. Helpful Information & Official Hotlines
                const SectionHeader(
                  title: 'Helpful Information',
                  subtitle: 'Official helplines and municipal contacts',
                ),
                const SizedBox(height: AppSpacing.xs),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.md + 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
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
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.phone_in_talk_outlined, size: 16, color: AppColors.primaryNavy),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Text(
                            'Official Citizen Hotlines',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Direct dial toll-free numbers for election queries and emergency municipal grievances:',
                        style: AppTextStyles.supporting,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: _helplinePill(
                              label: 'Voter Helpline: 1950',
                              subtext: 'ECI National Assistance',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _helplinePill(
                              label: 'Civic Grievance: 1913',
                              subtext: 'Ward Municipal Control',
                            ),
                          ),
                        ],
                      ),
                    ],
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


  Widget _helplinePill({required String label, required String subtext}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 1),
          Text(
            subtext,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

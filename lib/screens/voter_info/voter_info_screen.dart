import 'package:flutter/material.dart';
import '../../models/voter_info.dart';
import '../../services/voter_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/search_field.dart';
import '../../widgets/section_header.dart';
import 'voter_detail_screen.dart';

class VoterInfoScreen extends StatefulWidget {
  final bool isEmbedded;

  const VoterInfoScreen({super.key, this.isEmbedded = false});

  @override
  State<VoterInfoScreen> createState() => _VoterInfoScreenState();
}

class _VoterInfoScreenState extends State<VoterInfoScreen> {
  final VoterService _voterService = VoterService();
  final TextEditingController _searchController = TextEditingController();

  List<VoterInfo> _allGuides = [];
  List<VoterInfo> _displayedGuides = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Voter Registration',
    'Eligibility',
    'Required Documents',
    'Address Update',
    'Voter ID',
    'Polling Information',
    'Frequently Asked Questions',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _voterService.getVoterGuides();
    setState(() {
      _allGuides = data;
      _displayedGuides = data;
      _isLoading = false;
    });
  }

  void _applyFilter() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _displayedGuides = _allGuides.where((guide) {
        final matchesCategory = _selectedCategory == 'All' ||
            guide.category.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
            _selectedCategory.toLowerCase().contains(guide.category.toLowerCase());

        final matchesQuery = query.isEmpty ||
            guide.name.toLowerCase().contains(query) ||
            guide.summary.toLowerCase().contains(query) ||
            guide.faqs.any((f) =>
                f.question.toLowerCase().contains(query) ||
                f.answer.toLowerCase().contains(query));

        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        // Prominent but compact search field & Category chips
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
          color: AppColors.surfaceWhite,
          child: Column(
            children: [
              CivicSearchField(
                controller: _searchController,
                hintText: 'Search Form 6, eligibility, voter ID, address...',
                onChanged: (_) => _applyFilter(),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Horizontal Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs + 2),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _applyFilter();
                        },
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // List Area
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    children: [
                      // Educational disclaimer banner
                      const InfoBanner(
                        text:
                            'Notice: Informational guides summarized for citizen education. For statutory procedures and official filings, use the official election authority links below.',
                        type: BannerType.sampleData,
                      ),
                      const SizedBox(height: AppSpacing.md),

                      if (_displayedGuides.isEmpty)
                        EmptyState(
                          icon: Icons.search_off_outlined,
                          title: 'No matching voter topics found',
                          description: 'Try clearing your search keywords or select "All" topics.',
                          actionLabel: 'Show All Guides',
                          onAction: () {
                            setState(() {
                              _selectedCategory = 'All';
                              _searchController.clear();
                              _displayedGuides = _allGuides;
                            });
                          },
                        )
                      else ...[
                        SectionHeader(
                          title: 'Voter Information Sections',
                          subtitle: '${_displayedGuides.length} topics available • Tap to view summary',
                        ),
                        const SizedBox(height: AppSpacing.xs),

                        ..._displayedGuides.map((guide) => _buildGuideExpansionCard(guide)),
                      ],

                      const SizedBox(height: AppSpacing.xl),

                      // Official Sources Section (Clearly distinguished from sample content)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md + 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.secondaryTeal.withValues(alpha: 0.3)),
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
                                    color: AppColors.secondaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.verified_outlined, size: 16, color: AppColors.secondaryDark),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                const Text(
                                  'Official Sources & Portals',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              'Direct links to official statutory election portals operated by the Election Commission of India:',
                              style: AppTextStyles.supporting,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            _buildOfficialPortalCard(
                              title: 'National Voter’s Service Portal (voters.eci.gov.in)',
                              subtitle: 'Official national portal for Form 6 registration, Form 8 corrections, and digital e-EPIC download.',
                              authority: 'Election Commission of India (ECI)',
                              url: 'https://voters.eci.gov.in',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _buildOfficialPortalCard(
                              title: 'Electoral Roll Search (electoralsearch.eci.gov.in)',
                              subtitle: 'Verify your name on the official voter list and locate your designated polling station.',
                              authority: 'Official Electoral Roll Service',
                              url: 'https://electoralsearch.eci.gov.in',
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            _buildOfficialPortalCard(
                              title: 'Toll-free Voter Helpline: 1950',
                              subtitle: 'National citizen assistance hotline operated by the Election Commission of India.',
                              authority: 'ECI National Call Center',
                              url: 'tel:1950',
                              isPhone: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
        ),
      ],
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Voter Information'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(child: content),
    );
  }

  Widget _buildGuideExpansionCard(VoterInfo guide) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        leading: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(_getCategoryIcon(guide.category), size: 16, color: AppColors.primaryNavy),
        ),
        title: Text(
          guide.name,
          style: AppTextStyles.cardTitle,
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                guide.category,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (guide.steps.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.xs + 2),
              Text(
                '${guide.steps.length} Steps',
                style: AppTextStyles.metadata,
              ),
            ],
          ],
        ),
        children: [
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            guide.summary,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.sm + 2),

          // Eligibility preview
          if (guide.eligibility.isNotEmpty) ...[
            const Text(
              'Eligibility Criteria:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 3),
            Text(
              guide.eligibility,
              style: AppTextStyles.supporting,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // FAQs preview
          if (guide.faqs.isNotEmpty) ...[
            const Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            ...guide.faqs.take(2).map((faq) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q: ${faq.question}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryNavy)),
                      const SizedBox(height: 1),
                      Text('A: ${faq.answer}',
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.3)),
                    ],
                  ),
                )),
          ],

          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VoterDetailScreen(guide: guide)),
                );
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('View Full Instructions & Documents', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialPortalCard({
    required String title,
    required String subtitle,
    required String authority,
    required String url,
    bool isPhone = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'OFFICIAL SOURCE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryDark,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const Spacer(),
              Icon(isPhone ? Icons.call : Icons.open_in_new, size: 13, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: AppTextStyles.supporting,
          ),
          const SizedBox(height: 4),
          Text(
            authority,
            style: AppTextStyles.metadata,
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'voter registration':
        return Icons.how_to_reg_outlined;
      case 'eligibility':
        return Icons.verified_user_outlined;
      case 'required documents':
        return Icons.file_copy_outlined;
      case 'address update':
        return Icons.home_work_outlined;
      case 'voter id':
      case 'voter id information':
        return Icons.badge_outlined;
      case 'polling information':
        return Icons.where_to_vote_outlined;
      case 'frequently asked questions':
      case 'faq':
        return Icons.help_outline_rounded;
      default:
        return Icons.info_outline;
    }
  }
}

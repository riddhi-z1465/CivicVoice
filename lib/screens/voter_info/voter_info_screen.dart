import 'package:flutter/material.dart';
import '../../models/voter_info.dart';
import '../../services/voter_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/info_banner.dart';
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
    'Address Update',
    'Voter ID Information',
    'FAQ',
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
            guide.category.toLowerCase() == _selectedCategory.toLowerCase();

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
        // Search & Category Filter Section
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          color: AppTheme.surfaceWhite,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilter(),
                decoration: InputDecoration(
                  hintText: 'Search Form 6, eligibility, e-EPIC...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textMuted),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _applyFilter();
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              // Horizontal Category Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // List View
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    children: [
                      // Official Source Notice
                      const InfoBanner(
                        text:
                            'Notice: General Information guides below are summarized for citizen convenience. '
                            'For statutory procedures and legal enrollment, consult the Official Election Authority links provided.',
                        type: BannerType.sampleData,
                      ),
                      const SizedBox(height: 14),

                      if (_displayedGuides.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          child: const Column(
                            children: [
                              Icon(Icons.search_off, size: 40, color: AppTheme.textMuted),
                              SizedBox(height: 10),
                              Text(
                                'No matching voter topics found',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Try clearing your search query or selecting "All" topics.',
                                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Voter Guides (${_displayedGuides.length})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Text(
                              'Tap to expand summary',
                              style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        ..._displayedGuides.map((guide) => _buildGuideExpansionCard(guide)),
                      ],

                      const SizedBox(height: 24),

                      // Official Source Section (Clearly distinguished)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBBF7D0)),
                          boxShadow: AppTheme.subtleShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.verified, size: 18, color: AppTheme.accentGreen),
                                const SizedBox(width: 8),
                                const Text(
                                  'Official Election Authorities & Portals',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Official state portals for legal voter enrollment, EPIC dispatch, and digital electoral rolls.',
                              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.35),
                            ),
                            const SizedBox(height: 12),

                            _buildOfficialPortalCard(
                              title: 'National Voter’s Service Portal (NVSP)',
                              subtitle: 'Primary portal for Form 6, 7, 8 online filings & e-EPIC download.',
                              authority: 'Election Commission of India (Official)',
                              url: 'https://voters.eci.gov.in',
                            ),
                            const SizedBox(height: 8),
                            _buildOfficialPortalCard(
                              title: 'National Electoral Roll Search (electoralsearch.eci.gov.in)',
                              subtitle: 'Check name, polling station, and booth number on the digital electoral roll.',
                              authority: 'Election Commission of India (Official)',
                              url: 'https://electoralsearch.eci.gov.in',
                            ),
                            const SizedBox(height: 8),
                            _buildOfficialPortalCard(
                              title: 'Toll-free Voter Helpline: 1950',
                              subtitle: 'Official national voter assistance hotline operated Mon–Sat 9 AM to 6 PM.',
                              authority: 'ECI National Call Center',
                              url: 'tel:1950',
                              isPhone: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Voter Information & Services'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(child: content),
    );
  }

  Widget _buildGuideExpansionCard(VoterInfo guide) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        shape: const Border(),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryNavy.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(_getCategoryIcon(guide.category), size: 18, color: AppTheme.primaryNavy),
        ),
        title: Text(
          guide.name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                guide.category,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            if (guide.steps.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                '${guide.steps.length} Steps',
                style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
              ),
            ],
          ],
        ),
        children: [
          const Divider(height: 1),
          const SizedBox(height: 10),
          Text(
            guide.summary,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          // Eligibility preview
          if (guide.eligibility.isNotEmpty) ...[
            const Text(
              'Eligibility Criteria:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              guide.eligibility,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 10),
          ],

          // FAQs preview
          if (guide.faqs.isNotEmpty) ...[
            const Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            ...guide.faqs.take(2).map((faq) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Q: ${faq.question}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryNavy)),
                      const SizedBox(height: 2),
                      Text('A: ${faq.answer}',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3)),
                    ],
                  ),
                )),
          ],

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonalIcon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => VoterDetailScreen(guide: guide)),
                );
              },
              icon: const Icon(Icons.arrow_forward, size: 14),
              label: const Text('View Full Instructions & Documents', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreenLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'OFFICIAL SOURCE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              Icon(isPhone ? Icons.call : Icons.open_in_new, size: 14, color: AppTheme.textMuted),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.3),
          ),
          const SizedBox(height: 4),
          Text(
            authority,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.textMuted),
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
      case 'address update':
        return Icons.home_work_outlined;
      case 'voter id information':
        return Icons.badge_outlined;
      case 'faq':
        return Icons.help_outline_rounded;
      default:
        return Icons.info_outline;
    }
  }
}

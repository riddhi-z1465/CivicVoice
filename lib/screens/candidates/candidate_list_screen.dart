import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/candidate.dart';
import '../../providers/candidate_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/civic_card.dart';
import '../../widgets/info_banner.dart';
import 'candidate_detail_screen.dart';

class CandidateListScreen extends StatefulWidget {
  final bool isEmbedded;

  const CandidateListScreen({super.key, this.isEmbedded = false});

  @override
  State<CandidateListScreen> createState() => _CandidateListScreenState();
}

class _CandidateListScreenState extends State<CandidateListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final candidateProv = Provider.of<CandidateProvider>(context);

    final content = Column(
      children: [
        // Search and Constituency Filter Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          color: AppTheme.surfaceWhite,
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (val) => candidateProv.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search candidate name, party, or ward...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: AppTheme.textMuted),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            candidateProv.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              // Constituency Dropdown Filter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list, size: 16, color: AppTheme.primaryNavy),
                    const SizedBox(width: 8),
                    const Text('Ward:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: candidateProv.selectedConstituency,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
                          items: candidateProv.constituencies.map((c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child: Text(c, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              candidateProv.setConstituency(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // List Area
        Expanded(
          child: candidateProv.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => candidateProv.loadCandidates(),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    children: [
                      // Mandatory Neutrality Notice
                      const InfoBanner(
                        text:
                            'Notice: Public candidate information is displayed strictly for factual transparency without ranking, voting recommendations, or endorsements. Source: Sample Election Commission Affidavit Records.',
                        type: BannerType.sampleData,
                      ),
                      const SizedBox(height: 14),

                      if (candidateProv.candidates.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.center,
                          child: const Column(
                            children: [
                              Icon(Icons.person_search, size: 44, color: AppTheme.textMuted),
                              SizedBox(height: 10),
                              Text(
                                'No candidates match your criteria',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Try clearing search or switching to "All Constituencies"',
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
                              'Contesting Candidates (${candidateProv.candidates.length})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceMuted,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Form 26 Affidavits',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        ...candidateProv.candidates.map((candidate) {
                          return _buildCandidateCard(context, candidate);
                        }),
                      ],
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
        title: const Text('Candidate Public Profiles'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(child: content),
    );
  }

  Widget _buildCandidateCard(BuildContext context, Candidate candidate) {
    final initials = candidate.name
        .split(' ')
        .where((p) => p.isNotEmpty && !p.startsWith('Dr.'))
        .map((p) => p[0])
        .take(2)
        .join();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CivicCard(
        padding: const EdgeInsets.all(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CandidateDetailScreen(candidate: candidate),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clean photo placeholder with initials
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.primaryNavy.withValues(alpha: 0.15)),
                  ),
                  child: Center(
                    child: Text(
                      initials.isNotEmpty ? initials : 'CD',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryNavy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name, Constituency, and Party
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              candidate.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreenLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VERIFIED FILING',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentGreen,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        candidate.party,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryNavy,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textMuted),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              candidate.constituency,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                          Text(
                            'Age: ${candidate.age} yrs',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
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
            const SizedBox(height: 10),

            // Education & View Profile action
            Row(
              children: [
                const Icon(Icons.school_outlined, size: 14, color: AppTheme.textMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    candidate.education,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primaryNavy),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.chevron_right, size: 16, color: AppTheme.primaryNavy),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

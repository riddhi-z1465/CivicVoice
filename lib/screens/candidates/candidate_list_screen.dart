import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/candidate_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/candidate_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/search_field.dart';
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

  void _showConstituencyFilterSheet(BuildContext context, CandidateProvider provider) {
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
                    'Select Constituency / Ward',
                    style: AppTextStyles.sectionTitle,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Divider(),
                ...provider.constituencies.map((constituency) {
                  final isSelected = provider.selectedConstituency == constituency;
                  return ListTile(
                    title: Text(
                      constituency,
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
                      provider.setConstituency(constituency);
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
    final candidateProv = Provider.of<CandidateProvider>(context);

    final content = Column(
      children: [
        // Top Search and Filter Bar
        Container(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm + 2),
          color: AppColors.surfaceWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CivicSearchField(
                controller: _searchController,
                hintText: 'Search candidate name, party, or ward...',
                onChanged: (val) => candidateProv.setSearchQuery(val),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Filter Controls (Constituency pill and filter button)
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.filter_list, size: 14, color: AppColors.primaryNavy),
                            label: Text(
                              candidateProv.selectedConstituency,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                            backgroundColor: AppColors.primaryContainer,
                            side: const BorderSide(color: AppColors.borderSubtle),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            onPressed: () => _showConstituencyFilterSheet(context, candidateProv),
                          ),
                          if (candidateProv.selectedConstituency != 'All Constituencies') ...[
                            const SizedBox(width: AppSpacing.xs),
                            IconButton(
                              icon: const Icon(Icons.clear, size: 14, color: AppColors.textMuted),
                              tooltip: 'Reset to all constituencies',
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              onPressed: () => candidateProv.setConstituency('All Constituencies'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${candidateProv.candidates.length} Contesting',
                    style: AppTextStyles.metadata,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Candidate List Area
        Expanded(
          child: candidateProv.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => candidateProv.loadCandidates(),
                  child: candidateProv.candidates.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: AppSpacing.xxl),
                            EmptyState(
                              icon: Icons.person_search_outlined,
                              title: 'No candidates match your search',
                              description: 'Try clearing your search query or reset the constituency filter.',
                              actionLabel: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                candidateProv.setSearchQuery('');
                                candidateProv.setConstituency('All Constituencies');
                              },
                            ),
                          ],
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                          children: [
                            // Neutrality Transparency Notice
                            const InfoBanner(
                              text:
                                  'Candidate profiles are published strictly for democratic transparency. CivicVoice does not rank, score, endorse, or recommend candidates.',
                              type: BannerType.sampleData,
                            ),
                            const SizedBox(height: AppSpacing.md),

                            ...candidateProv.candidates.map((candidate) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: CandidateCard(
                                  candidate: candidate,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CandidateDetailScreen(candidate: candidate),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
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
        title: const Text('Candidates'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(child: content),
    );
  }
}

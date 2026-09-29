import 'package:flutter/material.dart';
import '../../models/candidate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/info_banner.dart';

class CandidateDetailScreen extends StatelessWidget {
  final Candidate candidate;

  const CandidateDetailScreen({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final initials = candidate.name
        .split(' ')
        .where((p) => p.isNotEmpty && !p.startsWith('Dr.'))
        .map((p) => p[0])
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Candidate Public Profile'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Candidate Identification Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppTheme.primaryNavy.withValues(alpha: 0.15)),
                          ),
                          child: Center(
                            child: Text(
                              initials.isNotEmpty ? initials : 'CD',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryNavy,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceMuted,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  candidate.party.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryNavy,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                candidate.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textMuted),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: Text(
                                      candidate.constituency,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    // Metadata Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _quickMeta(label: 'Candidate Age', value: '${candidate.age} Years'),
                        _quickMeta(label: 'Filing Category', value: 'General Elector'),
                        _quickMeta(label: 'Verification', value: 'Public Form 26'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Public Profile Information Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Public Profile Information',
                    style: TextStyle(
                      fontSize: 14,
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
                      'Factual Records Only',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Education Section
              _buildFactualSection(
                title: 'Education',
                icon: Icons.school_outlined,
                content: candidate.education,
              ),
              const SizedBox(height: 12),

              // Declared Professional Information
              _buildFactualSection(
                title: 'Declared Professional Background',
                icon: Icons.work_outline,
                content: candidate.professionalInformation,
              ),
              const SizedBox(height: 12),

              // Publicly Available Background & Platform
              _buildFactualSection(
                title: 'Public Platform & Priority Areas',
                icon: Icons.history_edu_outlined,
                content: candidate.background,
              ),
              const SizedBox(height: 12),

              // Relevant Official Information / Asset Declarations
              _buildFactualSection(
                title: 'Financial & Asset Declarations (Form 26 Affidavit)',
                icon: Icons.account_balance_wallet_outlined,
                content: candidate.declaredAssets,
              ),
              const SizedBox(height: 14),

              // Source Attribution Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield_outlined, size: 14, color: AppTheme.accentGreen),
                        SizedBox(width: 6),
                        Text(
                          'Public Registry Source Attribution',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      candidate.source,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Neutrality Disclaimer Banner
              const InfoBanner(
                text:
                    'CivicVoice presents candidate profiles strictly for democratic transparency. No candidate ratings, vote endorsements, or political advertisements are permitted on this platform.',
                type: BannerType.sampleData,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickMeta({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        const SizedBox(height: 1),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildFactualSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: AppTheme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryNavy),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          Text(
            content.isNotEmpty ? content : 'Information not declared in public filing.',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

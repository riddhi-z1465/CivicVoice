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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Candidate Profile'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Photo / Initials Header
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderMedium, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      initials.isNotEmpty ? initials : 'CD',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Candidate Name
              Text(
                candidate.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Constituency
              Text(
                candidate.constituency,
                textAlign: TextAlign.center,
                style: AppTextStyles.supporting,
              ),
              const SizedBox(height: 2),

              // Party / Affiliation
              Text(
                candidate.party,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryTeal,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Neutral verified badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  'Age: ${candidate.age} yrs • Public Form 26 Affidavit',
                  style: AppTextStyles.metadata,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // About Section
              _buildProfileSection(
                title: 'About',
                content: candidate.background.isNotEmpty
                    ? candidate.background
                    : 'Publicly declared background information as submitted in nomination records.',
              ),
              const SizedBox(height: AppSpacing.lg),

              // Education Section
              _buildProfileSection(
                title: 'Education',
                content: candidate.education,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Professional Information Section
              _buildProfileSection(
                title: 'Professional Information',
                content: candidate.professionalInformation,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Declared Assets / Financials (if available)
              if (candidate.declaredAssets.isNotEmpty) ...[
                _buildProfileSection(
                  title: 'Asset & Liability Declarations',
                  content: candidate.declaredAssets,
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Source Attribution Section
              _buildProfileSection(
                title: 'Source',
                content: candidate.source,
                isSource: true,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Neutrality Notice Banner
              const InfoBanner(
                text:
                    'This candidate profile is presented neutrally for informational purposes. CivicVoice does not endorse candidates, compile rankings, or provide voting advice.',
                type: BannerType.sampleData,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection({
    required String title,
    required String content,
    bool isSource = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: isSource ? AppColors.textMuted : AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/voter_info.dart';
import '../../theme/app_theme.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/section_header.dart';

class VoterDetailScreen extends StatelessWidget {
  final VoterInfo guide;

  const VoterDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(guide.name),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge & Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      guide.category.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNavy,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                guide.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppTheme.subtleShadow,
                ),
                child: Text(
                  guide.summary,
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Eligibility
              if (guide.eligibility.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Statutory Eligibility',
                  subtitle: 'Legal qualification required for this procedure',
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Text(
                    guide.eligibility,
                    style: AppTextStyles.body,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Required Documents
              if (guide.documents.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Required Supporting Documents',
                  subtitle: 'Documents accepted by the Electoral Registration Officer',
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    children: guide.documents.map((doc) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 16, color: AppColors.secondaryTeal),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                doc,
                                style: AppTextStyles.body,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Procedural Steps
              if (guide.steps.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Step-by-Step Procedure',
                  subtitle: 'Official process for submission and verification',
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    children: List.generate(guide.steps.length, (idx) {
                      final stepText = guide.steps[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.primaryNavy,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  '${idx + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm + 2),
                            Expanded(
                              child: Text(
                                stepText,
                                style: AppTextStyles.body,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Official Portals & Sources
              if (guide.officialLinks.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Official Portals',
                  subtitle: 'Government authorized links for online filing',
                ),
                const SizedBox(height: AppSpacing.xs),
                ...guide.officialLinks.map((link) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.secondaryTeal.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified, size: 18, color: AppColors.secondaryTeal),
                        const SizedBox(width: AppSpacing.sm + 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                link.label,
                                style: AppTextStyles.cardTitle,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                link.authorityName,
                                style: AppTextStyles.metadata,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.open_in_new, size: 15, color: AppColors.secondaryTeal),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.xl),
              ],

              // FAQs
              if (guide.faqs.isNotEmpty) ...[
                const SectionHeader(
                  title: 'Frequently Asked Questions',
                  subtitle: 'Common citizen queries answered',
                ),
                const SizedBox(height: AppSpacing.xs),
                ...guide.faqs.map((faq) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceWhite,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faq.question,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          faq.answer,
                          style: AppTextStyles.supporting.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.lg),
              ],

              const InfoBanner(
                text:
                    'Statutory Disclaimer: Information provided in CivicVoice is for educational demonstration. Official notifications and statutory guidelines published by the Election Commission prevail.',
                type: BannerType.sampleData,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/candidate.dart';
import '../theme/app_theme.dart';
import 'civic_card.dart';

/// Standardized Candidate Card adhering to civic utility guidelines:
/// [Photo/Initials]  Candidate Name
///                   Constituency
///                   Party / Affiliation
///                   View Profile →
class CandidateCard extends StatelessWidget {
  final Candidate candidate;
  final VoidCallback onTap;

  const CandidateCard({
    super.key,
    required this.candidate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = candidate.name
        .split(' ')
        .where((p) => p.isNotEmpty && !p.startsWith('Dr.'))
        .map((p) => p[0])
        .take(2)
        .join();

    return CivicCard(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo / Initials avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.borderMedium, width: 0.8),
                ),
                child: Center(
                  child: Text(
                    initials.isNotEmpty ? initials : 'CD',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Name, Constituency, Party
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      candidate.name,
                      style: AppTextStyles.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      candidate.constituency,
                      style: AppTextStyles.supporting,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      candidate.party,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTeal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),

          // Footer action: Education summary + View Profile →
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.school_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        candidate.education,
                        style: AppTextStyles.metadata,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Profile',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primaryNavy),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

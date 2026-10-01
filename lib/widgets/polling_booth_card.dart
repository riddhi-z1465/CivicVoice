import 'package:flutter/material.dart';
import '../models/polling_booth.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'civic_card.dart';

/// Standardized Polling Booth Card:
/// [Booth Name]
/// [Booth Number]
///
/// [Distance]
/// [Address]
///
/// [View Details] [Directions]
class PollingBoothCard extends StatelessWidget {
  final PollingBooth booth;
  final VoidCallback onDetailsTap;
  final VoidCallback? onDirectionsTap;

  const PollingBoothCard({
    super.key,
    required this.booth,
    required this.onDetailsTap,
    this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return CivicCard(
      padding: const EdgeInsets.all(AppSpacing.md + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.where_to_vote_outlined, size: 18, color: AppColors.primaryNavy),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booth.name,
                      style: AppTextStyles.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booth.boothNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
              if (booth.wheelchairAccessible)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.accessible, size: 12, color: AppColors.textSecondary),
                      SizedBox(width: 3),
                      Text('Ramp', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          Row(
            children: [
              const Icon(Icons.straighten, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '${Formatters.formatDistance(booth.distanceKm)} away',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Icon(Icons.place_outlined, size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  booth.address,
                  style: AppTextStyles.supporting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDirectionsTap != null) ...[
                OutlinedButton.icon(
                  onPressed: onDirectionsTap,
                  icon: const Icon(Icons.directions, size: 13),
                  label: const Text('Directions', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              FilledButton(
                onPressed: onDetailsTap,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('View Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

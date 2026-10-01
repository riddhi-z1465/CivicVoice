import 'package:flutter/material.dart';
import '../../models/polling_booth.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/info_banner.dart';
import '../../widgets/section_header.dart';

class BoothDetailScreen extends StatelessWidget {
  final PollingBooth booth;

  const BoothDetailScreen({super.key, required this.booth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(booth.boothNumber),
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
              // Booth Header Card
              Container(
                width: double.infinity,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            Formatters.formatDistance(booth.distanceKm),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        if (booth.wheelchairAccessible)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.accessible, size: 13, color: AppColors.textSecondary),
                                SizedBox(width: 4),
                                Text(
                                  'Wheelchair Ramp Available',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      booth.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booth.address,
                      style: AppTextStyles.supporting.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Station Specification Details
              const SectionHeader(
                title: 'Station Particulars',
                subtitle: 'Official designated booth and officer information',
              ),
              const SizedBox(height: AppSpacing.xs),

              _buildDetailItem(
                icon: Icons.tag,
                title: 'Official Booth Number',
                value: booth.boothNumber,
              ),
              const SizedBox(height: AppSpacing.sm),

              _buildDetailItem(
                icon: Icons.location_city_outlined,
                title: 'Electoral Constituency',
                value: booth.constituency,
              ),
              const SizedBox(height: AppSpacing.sm),

              if (booth.landmark.isNotEmpty) ...[
                _buildDetailItem(
                  icon: Icons.flag_outlined,
                  title: 'Prominent Landmark',
                  value: booth.landmark,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],

              _buildDetailItem(
                icon: Icons.person_pin_outlined,
                title: 'Designated Booth Officer',
                value: booth.contactOfficer,
              ),
              const SizedBox(height: AppSpacing.sm),

              _buildDetailItem(
                icon: Icons.phone_outlined,
                title: 'Officer Helplines',
                value: '${booth.contactPhone} / Toll-free 1950',
              ),
              const SizedBox(height: AppSpacing.xl),

              // Action: Directions
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Directions calculated for ${booth.name}. Simulated GPS routing.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.directions, size: 16),
                label: const Text('Open in Maps & Get Route'),
              ),
              const SizedBox(height: AppSpacing.md),

              const InfoBanner(
                text:
                    'Polling Station Guidelines: Only registered electors whose names appear on the corresponding electoral roll of this station are eligible to vote here. Carry valid identity proof on voting day.',
                type: BannerType.sampleData,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primaryNavy),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.metadata,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

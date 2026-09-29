import 'package:flutter/material.dart';
import '../../models/polling_booth.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../../widgets/info_banner.dart';

class BoothDetailScreen extends StatelessWidget {
  final PollingBooth booth;

  const BoothDetailScreen({super.key, required this.booth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(booth.boothNumber),
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
              // Booth Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            Formatters.formatDistance(booth.distanceKm),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (booth.wheelchairAccessible)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceMuted,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppTheme.borderSubtle),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.accessible, size: 14, color: AppTheme.textSecondary),
                                SizedBox(width: 4),
                                Text(
                                  'Wheelchair Ramp Available',
                                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      booth.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booth.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Station Specification Details
              const Text(
                'Station Particulars',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),

              _buildDetailItem(
                icon: Icons.tag,
                title: 'Official Booth Number',
                value: booth.boothNumber,
              ),
              const SizedBox(height: 10),

              _buildDetailItem(
                icon: Icons.location_city,
                title: 'Electoral Constituency',
                value: booth.constituency,
              ),
              const SizedBox(height: 10),

              if (booth.landmark.isNotEmpty) ...[
                _buildDetailItem(
                  icon: Icons.flag_outlined,
                  title: 'Prominent Landmark',
                  value: booth.landmark,
                ),
                const SizedBox(height: 10),
              ],

              _buildDetailItem(
                icon: Icons.person_pin,
                title: 'Designated Booth Officer',
                value: booth.contactOfficer,
              ),
              const SizedBox(height: 10),

              _buildDetailItem(
                icon: Icons.phone_outlined,
                title: 'Officer Helplines',
                value: '${booth.contactPhone} / Toll-free 1950',
              ),
              const SizedBox(height: 20),

              // Action: Directions
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Directions calculated for ${booth.name}. Simulated GPS routing.'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                icon: const Icon(Icons.directions, size: 18),
                label: const Text('Open in Maps & Get Route'),
              ),
              const SizedBox(height: 16),

              const InfoBanner(
                text:
                    'Polling Station Guidelines: Only registered electors whose names appear on the corresponding electoral roll of this station are eligible to vote here. Carry valid identity proof on voting day.',
                type: BannerType.sampleData,
              ),
              const SizedBox(height: 24),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryNavy),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
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

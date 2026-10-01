import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/section_header.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Municipal Management & Protocols'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Department SLA Targets Card
              const SectionHeader(
                title: 'Departmental Resolution Benchmarks (SLA)',
                subtitle: 'Mandated civic response targets for ward contractors',
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    _slaTile(
                      category: 'Street Light Maintenance',
                      department: 'Electrical Engineering Division',
                      sla: '48 Hours',
                      icon: Icons.lightbulb_outline,
                      color: AppColors.warningAmber,
                    ),
                    const Divider(height: 1),
                    _slaTile(
                      category: 'Road & Pothole Patch Repair',
                      department: 'Civil Infrastructure Works',
                      sla: '5 Business Days',
                      icon: Icons.add_road_outlined,
                      color: AppColors.primaryNavy,
                    ),
                    const Divider(height: 1),
                    _slaTile(
                      category: 'Garbage & Waste Clearance',
                      department: 'Solid Waste Management',
                      sla: '24 Hours',
                      icon: Icons.delete_outline,
                      color: AppColors.secondaryTeal,
                    ),
                    const Divider(height: 1),
                    _slaTile(
                      category: 'Water Supply & Pipeline Leaks',
                      department: 'Hydraulic Engineering Wing',
                      sla: '48 Hours',
                      icon: Icons.water_drop_outlined,
                      color: AppColors.infoBlue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 2. Ward & Area Jurisdiction
              const SectionHeader(
                title: 'Ward & Zone Jurisdiction',
                subtitle: 'Administrative sectors covered by this civic authority console',
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
                  children: [
                    _jurisdictionRow('Ward 12 (North Central)', 'Sector 1 to Sector 14', '18 Active Polling Stations'),
                    const Divider(height: 16),
                    _jurisdictionRow('Ward 15 (South Ward)', 'Station Road & Market Area', '14 Active Polling Stations'),
                    const Divider(height: 16),
                    _jurisdictionRow('East Civic District 04', 'Industrial & Commercial Hub', '9 Active Polling Stations'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 3. Technical Platform Health & Backend Sync
              const SectionHeader(
                title: 'System & Security Infrastructure',
                subtitle: 'Cloud backend status and security rule enforcement',
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
                  children: [
                    _systemStatusRow(
                      'Cloud Firestore (civicvoice-c476a)',
                      'Connected & Synchronized',
                      CivicFirebaseService.isInitialized,
                    ),
                    const Divider(height: 16),
                    _systemStatusRow(
                      'Role-Based Firestore Security Rules',
                      'Enforced (Citizens: Scoped read; Authority: Status write)',
                      true,
                    ),
                    const Divider(height: 16),
                    _systemStatusRow(
                      'Firebase Storage Bucket',
                      'Active (Evidence uploads)',
                      CivicFirebaseService.isInitialized,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slaTile({
    required String category,
    required String department,
    required String sla,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 1),
                Text(department, style: AppTextStyles.metadata),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Text(
              sla,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryNavy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _jurisdictionRow(String title, String sectors, String booths) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(sectors, style: AppTextStyles.metadata),
          ],
        ),
        Text(booths, style: const TextStyle(fontSize: 11.5, color: AppColors.secondaryTeal, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _systemStatusRow(String title, String description, bool isOnline) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isOnline ? AppColors.successGreen : AppColors.warningAmber,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(description, style: AppTextStyles.metadata),
            ],
          ),
        ),
      ],
    );
  }
}

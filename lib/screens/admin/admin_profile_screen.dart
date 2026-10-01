import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firebase_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Confirm Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          content: const Text(
            'Are you sure you want to end your administrative authority session on CivicVoice?',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final auth = Provider.of<AuthProvider>(context, listen: false);
                await auth.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.errorRed,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
    final officerName = user?.name ?? 'Riddhi Zunjarrao';
    final email = user?.email ?? 'admin@civicvoice.org';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Authority Profile & Console'),
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
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderSubtle),
                  boxShadow: AppTheme.subtleShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          officerName.isNotEmpty ? officerName[0].toUpperCase() : 'A',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  officerName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.borderSubtle),
                                ),
                                child: const Text(
                                  'AUTHORITY',
                                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.primaryNavy),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: AppTextStyles.supporting,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Designation: Ward Commissioner / Civic Authority',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.secondaryTeal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Administrative Jurisdiction Card
              const Text(
                'Jurisdiction & Division',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
                child: Column(
                  children: [
                    _infoTile(
                      icon: Icons.account_balance_outlined,
                      label: 'Assigned Department',
                      value: 'Municipal Infrastructure & Public Grievance Directorate',
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      icon: Icons.map_outlined,
                      label: 'Supervised Zones',
                      value: 'North Central Ward 12, South Ward 15, East District 04',
                    ),
                    const Divider(height: 16),
                    _infoTile(
                      icon: Icons.verified_outlined,
                      label: 'Administrative Clearance',
                      value: 'Full Status Mutation & Field Team Dispatch Permitted',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Operational Settings
              const Text(
                'Operational Configuration',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Material(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cloud_done_outlined, color: AppColors.primaryNavy, size: 20),
                      title: const Text('Live Backend Sync', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        CivicFirebaseService.isInitialized ? 'Connected to civicvoice-c476a' : 'Dual-mode local caching active',
                        style: AppTextStyles.metadata,
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successBg,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.successBorder),
                        ),
                        child: const Text('ONLINE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.successGreen)),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.notifications_active_outlined, color: AppColors.primaryNavy, size: 20),
                      title: const Text('Urgent Grievance Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: const Text('Push alerts when public safety issues are logged', style: AppTextStyles.metadata),
                      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Urgent grievance alert notifications enabled.')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.menu_book_outlined, color: AppColors.primaryNavy, size: 20),
                      title: const Text('Municipal SLA Guidelines', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      subtitle: const Text('View public service resolution standards', style: AppTextStyles.metadata),
                      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            title: const Text('Civic SLA Guidelines', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                            content: const Text(
                              'Standard resolution timelines mandated by Municipal Corporation:\n\n'
                              '• Street Light Outages: 48 Hours\n'
                              '• Solid Waste Overflow: 24 Hours\n'
                              '• Potholes & Road Cratering: 5 Working Days\n'
                              '• Pipeline Leaks & Drainage: 48 Hours\n\n'
                              'Civic authorities must update the status history at every step of remediation.',
                              style: TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.textSecondary),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: const Icon(Icons.logout, size: 16, color: AppColors.errorRed),
                  label: const Text('Sign Out from Authority Console', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.errorBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile({required IconData icon, required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.metadata),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/civic_logo.dart';
import '../auth/login_screen.dart';
import 'edit_profile_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Confirm Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          content: const Text(
            'Are you sure you want to end your citizen session on CivicVoice?',
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
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        bool pushEnabled = true;
        bool smsEnabled = true;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text('Notification Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Issue Status Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Receive push alerts when your report is reviewed or resolved',
                        style: TextStyle(fontSize: 11)),
                    value: pushEnabled,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => pushEnabled = val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('SMS Civic Notices', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Receive official polling and election alerts via SMS',
                        style: TextStyle(fontSize: 11)),
                    value: smsEnabled,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => smsEnabled = val),
                  ),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preferences saved successfully.')),
                    );
                  },
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showPrivacyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Privacy Policy', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        content: const SingleChildScrollView(
          child: Text(
            'CivicVoice complies with guidelines for civic utility systems.\n\n'
            '• Personal credentials and mobile numbers are restricted to identity authentication.\n'
            '• Issue reports are submitted to municipal ward rosters with citizen protection.\n'
            '• No proprietary user tracking or third-party advertising analytics are executed in this application.',
            style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Help & FAQ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Official Electoral Helpline: 1950 (National)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Municipal Emergency Grievance: 1913', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Text(
              'Technical Support: For reporting issues, verify network status or use local offline simulation.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            CivicLogo(size: 48, showText: true, subtitle: 'Civic Services Made Accessible'),
            SizedBox(height: 14),
            Text(
              'CivicVoice is a public-service mobile application designed to empower citizens with accessible voter guidance, transparent candidate profiles, designated polling booth locators, and localized municipal grievance reporting.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              'Version 1.0.0 • College Project Prototype',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    final userName = user?.name ?? 'Riddhi Zunjarrao';
    final userEmail = user?.email ?? 'riddhi@example.com';

    final initials = userName
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.borderSubtle, height: 1),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Profile Avatar
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
                      initials.isNotEmpty ? initials : 'RZ',
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

              // 2. Citizen Name & Email
              Text(
                userName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                userEmail,
                textAlign: TextAlign.center,
                style: AppTextStyles.supporting,
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 3. Account Section
              _buildSectionTitle('Account'),
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
                    _buildSettingsTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const EditProfileDialog(),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.notifications_none_outlined,
                      title: 'Notifications',
                      onTap: () => _showNotificationSettings(context),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Privacy',
                      onTap: () => _showPrivacyInfo(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 4. Support Section
              _buildSectionTitle('Support'),
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
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: 'Help & FAQ',
                      onTap: () => _showHelpDialog(context),
                    ),
                    const Divider(height: 1),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: 'About CivicVoice',
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 5. Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: const Icon(Icons.logout, size: 16, color: AppColors.errorRed),
                  label: const Text('Logout', style: TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.errorBorder),
                    backgroundColor: AppColors.errorBg,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(0, 44),
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

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 19, color: AppColors.primaryNavy),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 17, color: AppColors.textMuted),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 0),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../auth/login_screen.dart';
import 'edit_profile_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Confirm Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          content: const Text(
            'Are you sure you want to end your citizen session on CivicVoice?',
            style: TextStyle(fontSize: 13),
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
                backgroundColor: const Color(0xFFDC2626),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Citizen Privacy & Data Protection', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        content: const SingleChildScrollView(
          child: Text(
            'CivicVoice complies with academic guidelines for civic technology prototypes.\n\n'
            '• Personal credentials and mobile numbers are restricted to authentication verification.\n'
            '• Issue reports are submitted to municipal ward rosters with citizen masking where requested.\n'
            '• No proprietary user tracking or third-party advertising analytics are executed in this application.',
            style: TextStyle(fontSize: 12, height: 1.4, color: AppTheme.textSecondary),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Civic Help & Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Official Electoral Helpline: 1950 (National)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            SizedBox(height: 4),
            Text('Municipal Emergency Grievance: 1913', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            SizedBox(height: 12),
            Text(
              'Technical Support: If you encounter an issue filing reports in the prototype, check network status or use the sample offline simulation features.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.35),
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

    final initials = user?.name
            .split(' ')
            .where((p) => p.isNotEmpty)
            .map((p) => p[0])
            .take(2)
            .join() ??
        'CP';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Citizen Profile'),
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
              // Digital Citizen ID Card Layout
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderSubtle),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryNavy,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(Icons.badge, size: 14, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'DIGITAL ELECTORAL CREDENTIAL',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryNavy,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreenLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, size: 11, color: AppTheme.accentGreen),
                              SizedBox(width: 4),
                              Text(
                                'VERIFIED',
                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.accentGreen),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryNavy,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Registered Citizen',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.email ?? 'citizen@civicvoice.org',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user?.phone.isNotEmpty == true ? '+91 ${user!.phone}' : '+91 9876543210',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Electoral details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _idCardDetail(label: 'Voter ID (EPIC)', value: user?.epicNumber ?? 'EPIC-904128'),
                        _idCardDetail(label: 'Constituency', value: user?.constituency ?? 'Ward 12'),
                        _idCardDetail(label: 'Registered', value: Formatters.formatDate(user?.registeredAt)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Account Actions
              const Text(
                'Settings & Preferences',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Material(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(8),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderSubtle),
                    boxShadow: AppTheme.subtleShadow,
                  ),
                  child: Column(
                    children: [
                      _actionTile(
                        icon: Icons.edit_outlined,
                        title: 'Edit Citizen Profile',
                        subtitle: 'Update name, mobile, and residential ward',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => const EditProfileDialog(),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _actionTile(
                        icon: Icons.notifications_none_outlined,
                        title: 'Notification Settings',
                        subtitle: 'Status change alerts and polling notifications',
                        onTap: () => _showNotificationSettings(context),
                      ),
                      const Divider(height: 1),
                      _actionTile(
                        icon: Icons.lock_outline,
                        title: 'Citizen Privacy & Data Protection',
                        subtitle: 'Masking of public records & grievance log policy',
                        onTap: () => _showPrivacyInfo(context),
                      ),
                      const Divider(height: 1),
                      _actionTile(
                        icon: Icons.help_outline,
                        title: 'Help, FAQ & Official Hotlines',
                        subtitle: 'Toll-free 1950 and Ward 12 emergency numbers',
                        onTap: () => _showHelpDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Logout Button
              OutlinedButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                icon: const Icon(Icons.logout, size: 16, color: Color(0xFFDC2626)),
                label: const Text('Sign Out from CivicVoice', style: TextStyle(color: Color(0xFFDC2626))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  backgroundColor: const Color(0xFFFEF2F2),
                ),
              ),
              const SizedBox(height: 20),

              // Academic Information Tag
              const Center(
                child: Text(
                  'CivicVoice v1.0.0 • College Project Prototype',
                  style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _idCardDetail({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppTheme.primaryNavy),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
      onTap: onTap,
    );
  }
}

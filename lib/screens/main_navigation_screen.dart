import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'admin/admin_navigation.dart';
import 'dashboard/dashboard_screen.dart';
import 'voter_info/voter_info_screen.dart';
import 'candidates/candidate_list_screen.dart';
import 'polling_booths/polling_booth_screen.dart';
import 'reports/my_reports_screen.dart';
import 'profile/profile_screen.dart';
import 'auth/login_screen.dart';

/// Role-aware navigation entry: routes to AdminNavigation or CitizenNavigation
/// based on the authenticated user's role from Firestore/Auth.
class MainNavigationScreen extends StatelessWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }

    if (auth.isAdmin) {
      return AdminNavigation(initialIndex: initialIndex);
    }

    return CitizenNavigation(initialIndex: initialIndex);
  }
}

/// Dedicated navigation shell for the Citizen experience
class CitizenNavigation extends StatefulWidget {
  final int initialIndex;

  const CitizenNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<CitizenNavigation> createState() => CitizenNavigationState();
}

class CitizenNavigationState extends State<CitizenNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    if (index >= 0 && index < 4) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 4 Bottom Navigation Bar destinations: Home | Explore | Reports | Profile
    final List<Widget> screens = [
      DashboardScreen(onNavigateTab: switchTab),
      const ExploreHubScreen(),
      const MyReportsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceWhite,
          border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 1),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment),
              label: 'Reports',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

/// Hub screen for the "Explore" tab allowing citizens to switch between
/// Voter Information, Candidate Profiles, and Polling Booths
class ExploreHubScreen extends StatefulWidget {
  const ExploreHubScreen({super.key});

  @override
  State<ExploreHubScreen> createState() => _ExploreHubScreenState();
}

class _ExploreHubScreenState extends State<ExploreHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Explore Civic Services'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryNavy,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primaryNavy,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'Voter Info'),
            Tab(text: 'Candidates'),
            Tab(text: 'Polling Booths'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VoterInfoScreen(isEmbedded: true),
          CandidateListScreen(isEmbedded: true),
          PollingBoothScreen(isEmbedded: true),
        ],
      ),
    );
  }
}

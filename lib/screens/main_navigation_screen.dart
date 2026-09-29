import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart';
import 'voter_info/voter_info_screen.dart';
import 'candidates/candidate_list_screen.dart';
import 'polling_booths/polling_booth_screen.dart';
import 'reports/my_reports_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      bottomNavigationBar: NavigationBar(
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
      appBar: AppBar(
        title: const Text('Explore Civic Services'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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

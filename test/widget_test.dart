import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:civicvoice/models/candidate.dart';
import 'package:civicvoice/models/civic_report.dart';
import 'package:civicvoice/models/user_profile.dart';
import 'package:civicvoice/theme/app_theme.dart';
import 'package:civicvoice/widgets/candidate_card.dart';
import 'package:civicvoice/widgets/civic_logo.dart';
import 'package:civicvoice/widgets/report_card.dart';
import 'package:civicvoice/widgets/section_header.dart';
import 'package:civicvoice/widgets/status_badge.dart';

void main() {
  testWidgets('StatusBadge renders correctly with accessible label', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusBadge(status: 'Under Review'),
        ),
      ),
    );

    expect(find.text('Under Review'), findsOneWidget);
    expect(find.byIcon(Icons.pending_actions_rounded), findsOneWidget);
  });

  testWidgets('SectionHeader renders title and action label', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Recent Reports',
            actionLabel: 'View All',
            onAction: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Recent Reports'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);

    await tester.tap(find.text('View All'));
    expect(tapped, isTrue);
  });

  testWidgets('CandidateCard renders candidate information neutrally', (WidgetTester tester) async {
    final candidate = Candidate(
      id: 'c1',
      name: 'Sunita Sharma',
      constituency: 'Ward 12',
      party: 'Independent Citizens Forum',
      education: 'Master of Public Administration',
      background: 'Dedicated to community services.',
      declaredAssets: 'Rs 42,00,000 (Movable & Immovable)',
      professionalInformation: 'Community Social Worker',
      age: '44',
      source: 'State Election Commission Public Filing',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: CandidateCard(
            candidate: candidate,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Sunita Sharma'), findsOneWidget);
    expect(find.text('Ward 12'), findsOneWidget);
    expect(find.text('Independent Citizens Forum'), findsOneWidget);
    expect(find.text('View Profile'), findsOneWidget);
  });

  testWidgets('ReportCard displays title, category, and status', (WidgetTester tester) async {
    final report = CivicReport(
      id: 'CV-101',
      userId: 'u1',
      title: 'Street Light Not Working',
      category: 'Street Light',
      description: 'The pole #14 has been dark for 3 nights.',
      location: 'Main Road, Ward 12',
      status: 'Under Review',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: ReportCard(
            report: report,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Street Light Not Working'), findsOneWidget);
    expect(find.text('Street Light • Main Road, Ward 12'), findsOneWidget);
    expect(find.text('Under Review'), findsOneWidget);
  });

  test('UserProfile correctly distinguishes citizen and admin roles', () {
    final citizen = UserProfile(
      uid: 'c1',
      name: 'Aarav Patel',
      email: 'citizen@civicvoice.org',
      phone: '9876543210',
      role: 'citizen',
    );
    expect(citizen.isCitizen, isTrue);
    expect(citizen.isAdmin, isFalse);

    final admin = UserProfile(
      uid: 'a1',
      name: 'Riddhi Zunjarrao',
      email: 'admin@civicvoice.org',
      phone: '9820098200',
      role: 'admin',
    );
    expect(admin.isAdmin, isTrue);
    expect(admin.isCitizen, isFalse);
  });

  testWidgets('CivicLogo renders emblem and title properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CivicLogo(
            size: 64,
            showText: true,
            subtitle: 'Civic Services Made Accessible',
          ),
        ),
      ),
    );

    expect(find.byType(CivicLogo), findsOneWidget);
    expect(find.text('CivicServices Made Accessible', findRichText: true), findsNothing);
    expect(find.text('Civic Services Made Accessible'), findsOneWidget);
  });
}

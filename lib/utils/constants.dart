/// Application-wide constants for CivicVoice
class AppConstants {
  static const String appName = 'CivicVoice';
  static const String appTagline = 'Stay informed. Stay involved.';
  static const String appSubtitle = 'Centralized Civic Information & Issue Reporting Portal';

  // Issue Categories
  static const List<String> issueCategories = [
    'Road',
    'Street Light',
    'Garbage',
    'Water Supply',
    'Public Safety',
    'Drainage',
    'Traffic',
    'Other',
  ];

  // Report Statuses
  static const String statusSubmitted = 'Submitted';
  static const String statusUnderReview = 'Under Review';
  static const String statusInProgress = 'In Progress';
  static const String statusResolved = 'Resolved';
  static const String statusClosed = 'Closed';

  static const List<String> allStatuses = [
    statusSubmitted,
    statusUnderReview,
    statusInProgress,
    statusResolved,
    statusClosed,
  ];

  // Constituencies (Sample/Mock data for prototype)
  static const List<String> sampleConstituencies = [
    'All Constituencies',
    'North Central Ward 12',
    'South Ward 15',
    'East Civic District 04',
    'West Municipal Sector 09',
    'Central Metro Ward 01',
  ];

  // Official Sources Notice
  static const String sampleDataDisclaimer =
      'Notice: This application prototype uses curated sample data for educational demonstration. '
      'Official voter registration records and candidate affidavits should be verified with the competent State Election Authority.';
}

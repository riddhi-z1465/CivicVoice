/// Firebase Architecture Service Guide & Firestore Integration Schema
///
/// This class encapsulates the Firestore collection names, document paths,
/// and Firebase Storage buckets used in the CivicVoice architecture.
class FirebaseService {
  // Firestore Collections
  static const String colUsers = 'users';
  static const String colVoterInformation = 'voter_information';
  static const String colCandidates = 'candidates';
  static const String colPollingBooths = 'polling_booths';
  static const String colCivicReports = 'civic_reports';

  // Storage Buckets / Folders
  static const String storageReportsFolder = 'issue_reports';
  static const String storageAvatarsFolder = 'user_avatars';

  /// Document path helper for a specific user profile
  static String userDocPath(String uid) => '$colUsers/$uid';

  /// Document path helper for a civic issue report
  static String reportDocPath(String reportId) => '$colCivicReports/$reportId';

  /// Document path helper for a polling booth
  static String boothDocPath(String boothId) => '$colPollingBooths/$boothId';

  /// Document path helper for candidate profile
  static String candidateDocPath(String candidateId) => '$colCandidates/$candidateId';

  /// Security rules checklist for reference
  static const String securityRulesOverview = '''
  rules_version = '2';
  service cloud.firestore {
    match /databases/{database}/documents {
      // User Profiles
      match /users/{userId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      // Public Civic Information (Read-only for all, write for admin)
      match /voter_information/{infoId} {
        allow read: if true;
        allow write: if false; // Managed via admin console
      }
      match /candidates/{candidateId} {
        allow read: if true;
        allow write: if false;
      }
      match /polling_booths/{boothId} {
        allow read: if true;
        allow write: if false;
      }
      // Citizen Reports (Citizens can create, view their own or ward public reports)
      match /civic_reports/{reportId} {
        allow read: if request.auth != null;
        allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
        allow update: if request.auth != null && (
          resource.data.userId == request.auth.uid ||
          request.auth.token.role == 'admin'
        );
      }
    }
  }
  ''';
}

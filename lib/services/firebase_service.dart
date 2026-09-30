import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mock_data.dart';

/// Firebase Architecture Service Guide & Firestore Integration Schema
///
/// Encapsulates the Firestore collection names, document paths,
/// Storage buckets, and initial database seeding for the CivicVoice project.
class CivicFirebaseService {
  // Project Credentials Reference: civicvoice-c476a
  static const String projectId = 'civicvoice-c476a';
  static const String storageBucket = 'civicvoice-c476a.firebasestorage.app';

  // Firestore Collections
  static const String colUsers = 'users';
  static const String colVoterInformation = 'voter_information';
  static const String colCandidates = 'candidates';
  static const String colPollingBooths = 'polling_booths';
  static const String colCivicReports = 'civic_reports';

  // Storage Buckets / Folders
  static const String storageReportsFolder = 'issue_reports';
  static const String storageAvatarsFolder = 'user_avatars';

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Check if Firebase has been initialized successfully
  static bool get isInitialized {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Helper to automatically populate Firestore with the initial civic baseline
  /// records (Candidates, Voter Guides, Polling Booths) if the database is fresh.
  static Future<void> seedInitialDataIfEmpty() async {
    if (!isInitialized) return;

    try {
      // 1. Seed Candidates if empty
      final candSnap = await firestore.collection(colCandidates).limit(1).get();
      if (candSnap.docs.isEmpty) {
        final batch = firestore.batch();
        for (final candidate in MockData.getCandidates()) {
          final docRef = firestore.collection(colCandidates).doc(candidate.id);
          batch.set(docRef, candidate.toMap());
        }
        await batch.commit();
      }

      // 2. Seed Voter Information if empty
      final voterSnap = await firestore.collection(colVoterInformation).limit(1).get();
      if (voterSnap.docs.isEmpty) {
        final batch = firestore.batch();
        for (final guide in MockData.getVoterInformation()) {
          final docRef = firestore.collection(colVoterInformation).doc(guide.id);
          batch.set(docRef, guide.toMap());
        }
        await batch.commit();
      }

      // 3. Seed Polling Booths if empty
      final boothSnap = await firestore.collection(colPollingBooths).limit(1).get();
      if (boothSnap.docs.isEmpty) {
        final batch = firestore.batch();
        for (final booth in MockData.getPollingBooths()) {
          final docRef = firestore.collection(colPollingBooths).doc(booth.id);
          batch.set(docRef, booth.toMap());
        }
        await batch.commit();
      }

      // 4. Seed initial baseline reports if empty
      final reportSnap = await firestore.collection(colCivicReports).limit(1).get();
      if (reportSnap.docs.isEmpty) {
        final batch = firestore.batch();
        for (final report in MockData.getSampleReports()) {
          final docRef = firestore.collection(colCivicReports).doc(report.id);
          batch.set(docRef, report.toMap());
        }
        await batch.commit();
      }
    } catch (e) {
      // Quietly ignore seeding errors (e.g. offline or strict security rules)
    }
  }
}

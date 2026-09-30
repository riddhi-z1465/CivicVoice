import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../models/civic_report.dart';
import '../utils/formatters.dart';
import 'firebase_service.dart';
import 'mock_data.dart';

/// Service for creating, tracking, and retrieving civic issue reports
/// via Cloud Firestore and Firebase Storage (civicvoice-c476a)
class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<CivicReport> _localCache = [];
  int _sequenceCounter = 4;

  ReportService() {
    _localCache.addAll(MockData.getSampleReports());
  }

  /// Get list of reports from Cloud Firestore (with local cache fallback)
  Future<List<CivicReport>> getReports({String? userId}) async {
    if (CivicFirebaseService.isInitialized) {
      try {
        Query<Map<String, dynamic>> query = _firestore
            .collection(CivicFirebaseService.colCivicReports)
            .orderBy('createdAt', descending: true);

        if (userId != null && userId.isNotEmpty) {
          query = query.where('userId', isEqualTo: userId);
        }

        final snapshot = await query.get();

        if (snapshot.docs.isNotEmpty) {
          final cloudReports = snapshot.docs.map((doc) {
            return CivicReport.fromMap(doc.data(), id: doc.id);
          }).toList();

          _localCache.clear();
          _localCache.addAll(cloudReports);
          return cloudReports;
        } else {
          // If Firestore collection is empty, seed initial baseline reports
          await CivicFirebaseService.seedInitialDataIfEmpty();
        }
      } catch (e) {
        debugPrint('Firestore reports fetch notice: $e');
      }
    }

    // Sort local cache descending by date
    final list = List<CivicReport>.from(_localCache);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Submit a new civic issue report with optional image upload to Firebase Storage
  Future<CivicReport> submitReport({
    required String userId,
    required String title,
    required String category,
    required String description,
    required String location,
    double? latitude,
    double? longitude,
    String? imageUrl,
    XFile? imageFile,
  }) async {
    final reportId = Formatters.generateReportId(_sequenceCounter++);
    final now = DateTime.now();
    String? uploadedUrl = imageUrl;

    // 1. Upload photo to Firebase Storage if provided
    if (CivicFirebaseService.isInitialized && imageFile != null) {
      try {
        final storageRef = _storage
            .ref('${CivicFirebaseService.storageReportsFolder}/$reportId.jpg');

        if (kIsWeb) {
          final bytes = await imageFile.readAsBytes();
          final uploadTask = await storageRef.putData(
            bytes,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          uploadedUrl = await uploadTask.ref.getDownloadURL();
        } else {
          final file = File(imageFile.path);
          if (await file.exists()) {
            final uploadTask = await storageRef.putFile(
              file,
              SettableMetadata(contentType: 'image/jpeg'),
            );
            uploadedUrl = await uploadTask.ref.getDownloadURL();
          }
        }
      } catch (e) {
        debugPrint('Firebase Storage upload notice: $e');
      }
    }

    final newReport = CivicReport(
      id: reportId,
      userId: userId,
      title: title.trim(),
      category: category,
      description: description.trim(),
      location: location.trim(),
      latitude: latitude,
      longitude: longitude,
      imageUrl: uploadedUrl,
      status: 'Submitted',
      createdAt: now,
      updatedAt: now,
      statusHistory: [
        ReportStatusLog(
          status: 'Submitted',
          timestamp: now,
          remarks: 'Report registered through CivicVoice portal and assigned ID $reportId.',
        ),
      ],
    );

    // 2. Save document to Cloud Firestore
    if (CivicFirebaseService.isInitialized) {
      try {
        await _firestore
            .collection(CivicFirebaseService.colCivicReports)
            .doc(reportId)
            .set(newReport.toMap());
      } catch (e) {
        debugPrint('Firestore report set notice: $e');
      }
    }

    _localCache.insert(0, newReport);
    return newReport;
  }

  /// Update report status in Cloud Firestore
  Future<CivicReport> advanceReportStatus(
    String reportId,
    String newStatus,
    String remarks,
  ) async {
    final index = _localCache.indexWhere((r) => r.id == reportId);
    final now = DateTime.now();

    CivicReport current;
    if (index != -1) {
      current = _localCache[index];
    } else {
      current = CivicReport(
        id: reportId,
        userId: 'citizen-demo-01',
        title: 'Report $reportId',
        category: 'Other',
        description: '',
        location: 'Ward 12',
      );
    }

    final updatedHistory = List<ReportStatusLog>.from(current.statusHistory);
    updatedHistory.add(
      ReportStatusLog(
        status: newStatus,
        timestamp: now,
        remarks: remarks,
      ),
    );

    final updated = current.copyWith(
      status: newStatus,
      updatedAt: now,
      statusHistory: updatedHistory,
    );

    // Update in Cloud Firestore
    if (CivicFirebaseService.isInitialized) {
      try {
        await _firestore
            .collection(CivicFirebaseService.colCivicReports)
            .doc(reportId)
            .update(updated.toMap());
      } catch (e) {
        debugPrint('Firestore status update notice: $e');
      }
    }

    if (index != -1) {
      _localCache[index] = updated;
    } else {
      _localCache.insert(0, updated);
    }

    return updated;
  }

  /// Get report by ID
  CivicReport? getReportById(String reportId) {
    try {
      return _localCache.firstWhere((r) => r.id == reportId);
    } catch (_) {
      return null;
    }
  }
}

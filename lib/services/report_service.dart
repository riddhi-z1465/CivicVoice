import '../models/civic_report.dart';
import '../utils/formatters.dart';
import 'mock_data.dart';

/// Service for creating, tracking, and retrieving civic issue reports
class ReportService {
  final List<CivicReport> _reports = [];
  int _sequenceCounter = 4; // MockData already includes 0001, 0002, 0003

  ReportService() {
    _reports.addAll(MockData.getSampleReports());
  }

  /// Get list of all reports (or filtered by user)
  Future<List<CivicReport>> getReports({String? userId}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    // Sort descending by creation date
    final list = List<CivicReport>.from(_reports);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  /// Submit a new civic issue report
  Future<CivicReport> submitReport({
    required String userId,
    required String title,
    required String category,
    required String description,
    required String location,
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final reportId = Formatters.generateReportId(_sequenceCounter++);
    final now = DateTime.now();

    final newReport = CivicReport(
      id: reportId,
      userId: userId,
      title: title.trim(),
      category: category,
      description: description.trim(),
      location: location.trim(),
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
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

    _reports.insert(0, newReport);
    return newReport;
  }

  /// Update report status (useful for viva demo to illustrate progression through stages)
  Future<CivicReport> advanceReportStatus(String reportId, String newStatus, String remarks) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index == -1) throw Exception('Report not found');

    final current = _reports[index];
    final updatedHistory = List<ReportStatusLog>.from(current.statusHistory);
    final now = DateTime.now();

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

    _reports[index] = updated;
    return updated;
  }

  /// Get report by ID
  CivicReport? getReportById(String reportId) {
    try {
      return _reports.firstWhere((r) => r.id == reportId);
    } catch (_) {
      return null;
    }
  }
}

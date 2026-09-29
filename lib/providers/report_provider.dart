import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../services/report_service.dart';

/// Provider managing Civic Issue Reports, submission, and status tracking
class ReportProvider extends ChangeNotifier {
  final ReportService _reportService = ReportService();

  List<CivicReport> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedStatusFilter = 'All';
  String _selectedCategoryFilter = 'All';

  List<CivicReport> get reports => _filteredReports;
  List<CivicReport> get allReports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedCategoryFilter => _selectedCategoryFilter;

  /// Top 2-3 recent reports for dashboard
  List<CivicReport> get recentReports {
    final list = List<CivicReport>.from(_reports);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.take(3).toList();
  }

  ReportProvider() {
    loadReports();
  }

  Future<void> loadReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reports = await _reportService.getReports();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  List<CivicReport> get _filteredReports {
    return _reports.where((r) {
      bool matchesStatus = true;
      if (_selectedStatusFilter == 'Active') {
        matchesStatus = r.status != 'Resolved' && r.status != 'Closed';
      } else if (_selectedStatusFilter == 'Resolved') {
        matchesStatus = r.status == 'Resolved';
      } else if (_selectedStatusFilter != 'All') {
        matchesStatus = r.status.toLowerCase() == _selectedStatusFilter.toLowerCase();
      }

      bool matchesCategory = true;
      if (_selectedCategoryFilter != 'All') {
        matchesCategory = r.category.toLowerCase() == _selectedCategoryFilter.toLowerCase();
      }

      return matchesStatus && matchesCategory;
    }).toList();
  }

  /// Submit a new civic issue report
  Future<CivicReport?> submitReport({
    required String userId,
    required String title,
    required String category,
    required String description,
    required String location,
    double? latitude,
    double? longitude,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newReport = await _reportService.submitReport(
        userId: userId,
        title: title,
        category: category,
        description: description,
        location: location,
        latitude: latitude,
        longitude: longitude,
        imageUrl: imageUrl,
      );

      _reports.insert(0, newReport);
      _isLoading = false;
      notifyListeners();
      return newReport;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Advance report status for testing/presentation
  Future<bool> advanceStatus(String reportId, String newStatus, String remarks) async {
    try {
      final updated = await _reportService.advanceReportStatus(reportId, newStatus, remarks);
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        _reports[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}

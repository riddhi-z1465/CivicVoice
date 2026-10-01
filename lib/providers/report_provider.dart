import 'dart:async';
import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../services/report_service.dart';

/// Provider managing Civic Issue Reports, submission, and status tracking
/// Supports role-based separation:
/// - Citizens: Scoped access to own reports & status tracking
/// - Authorities: City-wide operational oversight, search, filtering & status resolution
class ReportProvider extends ChangeNotifier {
  final ReportService _reportService = ReportService();
  StreamSubscription<List<CivicReport>>? _reportsSubscription;

  List<CivicReport> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Citizen Filter State
  String _selectedStatusFilter = 'All';
  String _selectedCategoryFilter = 'All';

  // Admin Operational Filter State
  String _adminSearchQuery = '';
  String _adminStatusFilter = 'All';
  String _adminCategoryFilter = 'All';
  String _adminLocationFilter = 'All';
  String _adminSortOrder = 'newest'; // 'newest' | 'oldest'

  List<CivicReport> get reports => _filteredReports;
  List<CivicReport> get allReports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get selectedCategoryFilter => _selectedCategoryFilter;

  // Admin Filter Getters
  String get adminSearchQuery => _adminSearchQuery;
  String get adminStatusFilter => _adminStatusFilter;
  String get adminCategoryFilter => _adminCategoryFilter;
  String get adminLocationFilter => _adminLocationFilter;
  String get adminSortOrder => _adminSortOrder;

  // ---------------------------------------------------------------------------
  // OPERATIONAL STATISTICS (ADMIN OVERVIEW)
  // ---------------------------------------------------------------------------
  int get totalCount => _reports.length;

  int get pendingReviewCount => _reports.where((r) {
        final s = r.status.toLowerCase();
        return s == 'submitted' || s == 'under review';
      }).length;

  int get inProgressCount => _reports.where((r) {
        return r.status.toLowerCase() == 'in progress';
      }).length;

  int get resolvedCount => _reports.where((r) {
        final s = r.status.toLowerCase();
        return s == 'resolved' || s == 'closed';
      }).length;

  Map<String, int> get categoryCounts {
    final Map<String, int> counts = {};
    for (final r in _reports) {
      counts[r.category] = (counts[r.category] ?? 0) + 1;
    }
    return counts;
  }

  List<String> get uniqueLocations {
    final Set<String> locs = {};
    for (final r in _reports) {
      if (r.location.isNotEmpty) {
        locs.add(r.location);
      }
    }
    return locs.toList()..sort();
  }

  // ---------------------------------------------------------------------------
  // CITIZEN SCOPED METHODS
  // ---------------------------------------------------------------------------
  /// Get reports submitted exclusively by a given citizen
  List<CivicReport> getCitizenReports(String? userId, {String? statusFilter}) {
    if (userId == null || userId.isEmpty) return [];

    final userReports = _reports.where((r) => r.userId == userId).toList();
    userReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final filter = statusFilter ?? _selectedStatusFilter;
    if (filter == 'All') return userReports;

    return userReports.where((r) {
      if (filter == 'Active') {
        return r.status != 'Resolved' && r.status != 'Closed';
      } else if (filter == 'Resolved') {
        return r.status == 'Resolved' || r.status == 'Closed';
      }
      return r.status.toLowerCase() == filter.toLowerCase();
    }).toList();
  }

  /// Top recent reports for citizen dashboard (scoped to current citizen)
  List<CivicReport> getCitizenRecentReports(String? userId) {
    if (userId == null || userId.isEmpty) return [];
    final list = _reports.where((r) => r.userId == userId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.take(3).toList();
  }

  /// Top 2-3 recent reports for dashboard (fallback)
  List<CivicReport> get recentReports {
    final list = List<CivicReport>.from(_reports);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list.take(3).toList();
  }

  // ---------------------------------------------------------------------------
  // ADMIN FILTERED REPORTS
  // ---------------------------------------------------------------------------
  List<CivicReport> get adminReports {
    var list = List<CivicReport>.from(_reports);

    // 1. Search Query (matches ID, title, description, category, or location)
    if (_adminSearchQuery.trim().isNotEmpty) {
      final q = _adminSearchQuery.trim().toLowerCase();
      list = list.where((r) {
        return r.id.toLowerCase().contains(q) ||
            r.title.toLowerCase().contains(q) ||
            r.description.toLowerCase().contains(q) ||
            r.category.toLowerCase().contains(q) ||
            r.location.toLowerCase().contains(q);
      }).toList();
    }

    // 2. Status Filter
    if (_adminStatusFilter != 'All') {
      if (_adminStatusFilter == 'Pending') {
        list = list.where((r) => r.status == 'Submitted' || r.status == 'Under Review').toList();
      } else {
        list = list.where((r) => r.status.toLowerCase() == _adminStatusFilter.toLowerCase()).toList();
      }
    }

    // 3. Category Filter
    if (_adminCategoryFilter != 'All') {
      list = list.where((r) => r.category.toLowerCase() == _adminCategoryFilter.toLowerCase()).toList();
    }

    // 4. Location Filter
    if (_adminLocationFilter != 'All') {
      list = list.where((r) => r.location.toLowerCase().contains(_adminLocationFilter.toLowerCase())).toList();
    }

    // 5. Date Sort
    if (_adminSortOrder == 'oldest') {
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return list;
  }

  ReportProvider() {
    loadReports();
    _listenToRealtimeReports();
  }

  void _listenToRealtimeReports() {
    _reportsSubscription?.cancel();
    _reportsSubscription = _reportService.getReportsStream().listen(
      (realtimeReports) {
        _reports = realtimeReports;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Reports stream error: $e');
      },
    );
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

  // Citizen filter setters
  void setStatusFilter(String status) {
    _selectedStatusFilter = status;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategoryFilter = category;
    notifyListeners();
  }

  // Admin filter setters
  void setAdminSearchQuery(String query) {
    _adminSearchQuery = query;
    notifyListeners();
  }

  void setAdminStatusFilter(String status) {
    _adminStatusFilter = status;
    notifyListeners();
  }

  void setAdminCategoryFilter(String category) {
    _adminCategoryFilter = category;
    notifyListeners();
  }

  void setAdminLocationFilter(String location) {
    _adminLocationFilter = location;
    notifyListeners();
  }

  void setAdminSortOrder(String order) {
    _adminSortOrder = order;
    notifyListeners();
  }

  void clearAdminFilters() {
    _adminSearchQuery = '';
    _adminStatusFilter = 'All';
    _adminCategoryFilter = 'All';
    _adminLocationFilter = 'All';
    _adminSortOrder = 'newest';
    notifyListeners();
  }

  List<CivicReport> get _filteredReports {
    return _reports.where((r) {
      bool matchesStatus = true;
      if (_selectedStatusFilter == 'Active') {
        matchesStatus = r.status != 'Resolved' && r.status != 'Closed';
      } else if (_selectedStatusFilter == 'Resolved') {
        matchesStatus = r.status == 'Resolved' || r.status == 'Closed';
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
    dynamic imageFile,
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
        imageFile: imageFile,
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

  /// Official Status Update by Civic Authority (Updates Firestore & local cache)
  Future<bool> updateReportStatus(String reportId, String newStatus, String remarks) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _reportService.advanceReportStatus(reportId, newStatus, remarks);
      final index = _reports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        _reports[index] = updated;
      } else {
        _reports.insert(0, updated);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Legacy advance status
  Future<bool> advanceStatus(String reportId, String newStatus, String remarks) async {
    return updateReportStatus(reportId, newStatus, remarks);
  }

  @override
  void dispose() {
    _reportsSubscription?.cancel();
    super.dispose();
  }
}


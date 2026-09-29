import 'package:flutter/material.dart';
import '../models/polling_booth.dart';
import '../services/mock_data.dart';
import '../services/location_service.dart';

enum BoothViewMode { list, map }

/// Provider managing Polling Booth Locator, distance calculation, and view modes
class BoothProvider extends ChangeNotifier {
  List<PollingBooth> _allBooths = [];
  List<PollingBooth> _filteredBooths = [];
  bool _isLoading = false;
  String _searchQuery = '';
  BoothViewMode _viewMode = BoothViewMode.list;
  PollingBooth? _selectedBooth;

  List<PollingBooth> get booths => _filteredBooths;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  BoothViewMode get viewMode => _viewMode;
  PollingBooth? get selectedBooth => _selectedBooth;

  BoothProvider() {
    loadBooths();
  }

  void setViewMode(BoothViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void selectBooth(PollingBooth? booth) {
    _selectedBooth = booth;
    notifyListeners();
  }

  Future<void> loadBooths() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    _allBooths = MockData.getPollingBooths();

    // Recalculate distance from default citizen location
    _allBooths = _allBooths.map((b) {
      final dist = LocationService.calculateDistanceInKm(
        LocationService.defaultLatitude,
        LocationService.defaultLongitude,
        b.latitude,
        b.longitude,
      );
      return b.copyWith(distanceKm: dist);
    }).toList();

    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.trim().isEmpty) {
      _filteredBooths = List.from(_allBooths);
    } else {
      final q = _searchQuery.trim().toLowerCase();
      _filteredBooths = _allBooths.where((b) {
        return b.name.toLowerCase().contains(q) ||
            b.boothNumber.toLowerCase().contains(q) ||
            b.address.toLowerCase().contains(q) ||
            b.constituency.toLowerCase().contains(q);
      }).toList();
    }

    // Sort by distance ascending
    _filteredBooths.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }
}

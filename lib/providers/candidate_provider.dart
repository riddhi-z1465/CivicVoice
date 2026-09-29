import 'package:flutter/material.dart';
import '../models/candidate.dart';
import '../services/candidate_service.dart';

/// Provider managing Candidate Profiles browsing, searching, and constituency filtering
class CandidateProvider extends ChangeNotifier {
  final CandidateService _candidateService = CandidateService();

  List<Candidate> _allCandidates = [];
  List<Candidate> _filteredCandidates = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedConstituency = 'All Constituencies';

  List<Candidate> get candidates => _filteredCandidates;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedConstituency => _selectedConstituency;

  List<String> get constituencies => _candidateService.getAvailableConstituencies();

  CandidateProvider() {
    loadCandidates();
  }

  Future<void> loadCandidates() async {
    _isLoading = true;
    notifyListeners();

    _allCandidates = await _candidateService.getCandidates();
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setConstituency(String constituency) {
    _selectedConstituency = constituency;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredCandidates = _allCandidates.where((candidate) {
      final matchesQuery = _searchQuery.isEmpty ||
          candidate.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          candidate.party.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          candidate.constituency.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesConstituency = _selectedConstituency == 'All Constituencies' ||
          candidate.constituency.toLowerCase() == _selectedConstituency.toLowerCase();

      return matchesQuery && matchesConstituency;
    }).toList();
  }
}

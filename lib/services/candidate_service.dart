import '../models/candidate.dart';
import 'mock_data.dart';

/// Service for managing factual candidate profiles and constituency filtering
class CandidateService {
  List<Candidate> _candidates = [];

  CandidateService() {
    _candidates = MockData.getCandidates();
  }

  /// Get list of all candidates
  Future<List<Candidate>> getCandidates() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_candidates);
  }

  /// Filter candidates by search query and constituency
  Future<List<Candidate>> filterCandidates({
    String query = '',
    String constituency = 'All Constituencies',
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return _candidates.where((candidate) {
      final matchesQuery = query.isEmpty ||
          candidate.name.toLowerCase().contains(query.toLowerCase()) ||
          candidate.party.toLowerCase().contains(query.toLowerCase()) ||
          candidate.constituency.toLowerCase().contains(query.toLowerCase());

      final matchesConstituency = constituency == 'All Constituencies' ||
          candidate.constituency.toLowerCase() == constituency.toLowerCase();

      return matchesQuery && matchesConstituency;
    }).toList();
  }

  /// Get distinct list of constituencies
  List<String> getAvailableConstituencies() {
    final set = <String>{'All Constituencies'};
    for (var c in _candidates) {
      set.add(c.constituency);
    }
    return set.toList();
  }

  /// Get candidate by ID
  Candidate? getCandidateById(String id) {
    try {
      return _candidates.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

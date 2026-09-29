import '../models/voter_info.dart';
import 'mock_data.dart';

/// Service for managing Voter Information guides and FAQs
class VoterService {
  List<VoterInfo> _voterGuides = [];

  VoterService() {
    _voterGuides = MockData.getVoterInformation();
  }

  /// Get all voter information sections
  Future<List<VoterInfo>> getVoterGuides() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_voterGuides);
  }

  /// Search voter information by query
  Future<List<VoterInfo>> searchGuides(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query.trim().isEmpty) return _voterGuides;

    final q = query.trim().toLowerCase();
    return _voterGuides.where((guide) {
      final matchesName = guide.name.toLowerCase().contains(q);
      final matchesSummary = guide.summary.toLowerCase().contains(q);
      final matchesCategory = guide.category.toLowerCase().contains(q);
      final matchesFaq = guide.faqs.any((f) =>
          f.question.toLowerCase().contains(q) ||
          f.answer.toLowerCase().contains(q));
      return matchesName || matchesSummary || matchesCategory || matchesFaq;
    }).toList();
  }

  /// Get guide by ID
  VoterInfo? getGuideById(String id) {
    try {
      return _voterGuides.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}

/// Model for voter information sections, instructions, and FAQs
class VoterInfo {
  final String id;
  final String name; // e.g. "Voter Registration (Form 6)"
  final String category; // e.g. "Registration", "Eligibility", "Address Update", "Voter ID", "Polling", "FAQ"
  final String summary;
  final String eligibility;
  final List<String> documents;
  final List<String> steps;
  final List<OfficialLink> officialLinks;
  final bool isOfficialSource;
  final List<FaqItem> faqs;

  VoterInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    this.eligibility = '',
    this.documents = const [],
    this.steps = const [],
    this.officialLinks = const [],
    this.isOfficialSource = false,
    this.faqs = const [],
  });

  factory VoterInfo.fromMap(Map<String, dynamic> map, {String? id}) {
    return VoterInfo(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'General Information',
      summary: map['summary'] ?? '',
      eligibility: map['eligibility'] ?? '',
      documents: List<String>.from(map['documents'] ?? []),
      steps: List<String>.from(map['steps'] ?? []),
      officialLinks: (map['officialLinks'] as List<dynamic>?)
              ?.map((item) => OfficialLink.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
      isOfficialSource: map['isOfficialSource'] ?? false,
      faqs: (map['faqs'] as List<dynamic>?)
              ?.map((item) => FaqItem.fromMap(Map<String, dynamic>.from(item)))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'summary': summary,
      'eligibility': eligibility,
      'documents': documents,
      'steps': steps,
      'officialLinks': officialLinks.map((e) => e.toMap()).toList(),
      'isOfficialSource': isOfficialSource,
      'faqs': faqs.map((e) => e.toMap()).toList(),
    };
  }
}

class OfficialLink {
  final String label;
  final String url;
  final String authorityName;

  OfficialLink({
    required this.label,
    required this.url,
    required this.authorityName,
  });

  factory OfficialLink.fromMap(Map<String, dynamic> map) {
    return OfficialLink(
      label: map['label'] ?? '',
      url: map['url'] ?? '',
      authorityName: map['authorityName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'url': url,
      'authorityName': authorityName,
    };
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromMap(Map<String, dynamic> map) {
    return FaqItem(
      question: map['question'] ?? '',
      answer: map['answer'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

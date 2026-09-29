/// Model representing a factual candidate profile
class Candidate {
  final String id;
  final String name;
  final String constituency;
  final String party;
  final String? photoUrl;
  final String education;
  final String professionalInformation;
  final String background;
  final String source;
  final String declaredAssets;
  final String age;

  Candidate({
    required this.id,
    required this.name,
    required this.constituency,
    required this.party,
    this.photoUrl,
    required this.education,
    required this.professionalInformation,
    required this.background,
    required this.source,
    required this.declaredAssets,
    required this.age,
  });

  factory Candidate.fromMap(Map<String, dynamic> map, {String? id}) {
    return Candidate(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      constituency: map['constituency'] ?? '',
      party: map['party'] ?? 'Independent',
      photoUrl: map['photoUrl'],
      education: map['education'] ?? 'Declared under public affidavit',
      professionalInformation: map['professionalInformation'] ?? '',
      background: map['background'] ?? '',
      source: map['source'] ?? 'Public Election Commission Affidavit Records',
      declaredAssets: map['declaredAssets'] ?? 'As per affidavit filings',
      age: map['age']?.toString() ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'constituency': constituency,
      'party': party,
      'photoUrl': photoUrl,
      'education': education,
      'professionalInformation': professionalInformation,
      'background': background,
      'source': source,
      'declaredAssets': declaredAssets,
      'age': age,
    };
  }
}

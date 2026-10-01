/// Model representing an authenticated user profile (citizen or civic authority admin)
class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role; // 'citizen' or 'admin'
  final String? constituency;
  final String? epicNumber; // Electoral Photo Identity Card Number
  final DateTime registeredAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'citizen',
    this.constituency,
    this.epicNumber,
    DateTime? registeredAt,
  }) : registeredAt = registeredAt ?? DateTime.now();

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isCitizen => !isAdmin;

  factory UserProfile.fromMap(Map<String, dynamic> map, {String? id}) {
    return UserProfile(
      uid: id ?? map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'citizen',
      constituency: map['constituency'],
      epicNumber: map['epicNumber'],
      registeredAt: map['registeredAt'] != null
          ? (map['registeredAt'] is DateTime
              ? map['registeredAt'] as DateTime
              : DateTime.tryParse(map['registeredAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'constituency': constituency,
      'epicNumber': epicNumber,
      'registeredAt': registeredAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? constituency,
    String? epicNumber,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      constituency: constituency ?? this.constituency,
      epicNumber: epicNumber ?? this.epicNumber,
      registeredAt: registeredAt,
    );
  }
}

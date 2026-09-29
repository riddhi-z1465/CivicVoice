/// Model representing a Polling Booth location
class PollingBooth {
  final String id;
  final String name;
  final String boothNumber;
  final String address;
  final double latitude;
  final double longitude;
  final String constituency;
  final double distanceKm;
  final String landmark;
  final bool wheelchairAccessible;
  final String contactOfficer;
  final String contactPhone;

  PollingBooth({
    required this.id,
    required this.name,
    required this.boothNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.constituency,
    this.distanceKm = 0.0,
    this.landmark = '',
    this.wheelchairAccessible = true,
    this.contactOfficer = 'Election Polling Officer',
    this.contactPhone = '1800-111-999',
  });

  factory PollingBooth.fromMap(Map<String, dynamic> map, {String? id}) {
    return PollingBooth(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      boothNumber: map['boothNumber'] ?? '',
      address: map['address'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      constituency: map['constituency'] ?? '',
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 0.0,
      landmark: map['landmark'] ?? '',
      wheelchairAccessible: map['wheelchairAccessible'] ?? true,
      contactOfficer: map['contactOfficer'] ?? 'Election Polling Officer',
      contactPhone: map['contactPhone'] ?? '1800-111-999',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'boothNumber': boothNumber,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'constituency': constituency,
      'distanceKm': distanceKm,
      'landmark': landmark,
      'wheelchairAccessible': wheelchairAccessible,
      'contactOfficer': contactOfficer,
      'contactPhone': contactPhone,
    };
  }

  PollingBooth copyWith({
    double? distanceKm,
  }) {
    return PollingBooth(
      id: id,
      name: name,
      boothNumber: boothNumber,
      address: address,
      latitude: latitude,
      longitude: longitude,
      constituency: constituency,
      distanceKm: distanceKm ?? this.distanceKm,
      landmark: landmark,
      wheelchairAccessible: wheelchairAccessible,
      contactOfficer: contactOfficer,
      contactPhone: contactPhone,
    );
  }
}

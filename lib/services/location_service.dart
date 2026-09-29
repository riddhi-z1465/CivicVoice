import 'dart:math' as math;

/// Service for handling location queries, coordinates, and distance calculations.
///
/// Designed with built-in realistic mock location handling so the application functions
/// seamlessly without requiring expensive proprietary Google Maps API keys or hardware permissions.
class LocationService {
  // Default citizen reference location (North Central Ward 12 center)
  static const double defaultLatitude = 19.0760;
  static const double defaultLongitude = 72.8777;
  static const String defaultAreaName = 'North Central Ward 12, Civil District';

  /// Pre-defined recognizable municipal localities for manual picker
  static const List<Map<String, dynamic>> municipalLocations = [
    {
      'name': 'North Central Ward 12 (MG Road)',
      'address': 'MG Road & Municipal Complex, Ward 12',
      'lat': 19.0760,
      'lng': 72.8777,
    },
    {
      'name': 'South Ward 15 (Civil Lines)',
      'address': 'Civil Lines Main Road, Ward 15',
      'lat': 19.0680,
      'lng': 72.8710,
    },
    {
      'name': 'East Civic District 04 (Bazaar Link)',
      'address': 'District Library Road, Ward 04',
      'lat': 19.0910,
      'lng': 72.8950,
    },
    {
      'name': 'West Municipal Sector 09 (Sports Complex)',
      'address': 'Ring Road & Sector 9 Avenue',
      'lat': 19.0550,
      'lng': 72.8590,
    },
    {
      'name': 'Central Metro Junction (Station Road)',
      'address': 'Station Approach Road, Sector 3',
      'lat': 19.0820,
      'lng': 72.8840,
    },
  ];

  /// Simulates fetching device's current GPS position
  Future<Map<String, dynamic>> getCurrentPosition() async {
    // Artificial brief delay to simulate GPS satellite lock
    await Future.delayed(const Duration(milliseconds: 600));

    return {
      'latitude': defaultLatitude,
      'longitude': defaultLongitude,
      'address': 'Near MG Road, North Central Ward 12 (Current GPS Position)',
    };
  }

  /// Calculates geodesic distance between two latitude/longitude points in Kilometers
  /// Using the Haversine formula
  static double calculateDistanceInKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }
}

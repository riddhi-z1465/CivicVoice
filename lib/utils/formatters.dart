import 'package:intl/intl.dart';

/// Formatting helper methods for dates, IDs, and distances.
class Formatters {
  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _dateTimeFormat = DateFormat('dd MMM yyyy, hh:mm a');

  static String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return _dateFormat.format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return 'N/A';
    return _dateTimeFormat.format(date);
  }

  static String formatDistance(double km) {
    if (km < 1.0) {
      final meters = (km * 1000).round();
      return '$meters m away';
    }
    return '${km.toStringAsFixed(1)} km away';
  }

  /// Generates a standardized realistic civic report ID
  /// Format: CV-2026-XXXX
  static String generateReportId(int sequenceNumber) {
    final year = DateTime.now().year;
    final paddedNumber = sequenceNumber.toString().padLeft(4, '0');
    return 'CV-$year-$paddedNumber';
  }
}

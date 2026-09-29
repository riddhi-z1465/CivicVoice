/// Model representing a citizen-reported civic issue
class CivicReport {
  final String id;
  final String userId;
  final String title;
  final String category;
  final String description;
  final String location;
  final double? latitude;
  final double? longitude;
  final String? imageUrl;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ReportStatusLog> statusHistory;

  CivicReport({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    this.latitude,
    this.longitude,
    this.imageUrl,
    this.status = 'Submitted',
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ReportStatusLog>? statusHistory,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        statusHistory = statusHistory ??
            [
              ReportStatusLog(
                status: 'Submitted',
                timestamp: createdAt ?? DateTime.now(),
                remarks: 'Report received and assigned ID $id',
              )
            ];

  factory CivicReport.fromMap(Map<String, dynamic> map, {String? id}) {
    final reportId = id ?? map['id'] ?? '';
    final created = map['createdAt'] != null
        ? (map['createdAt'] is DateTime
            ? map['createdAt'] as DateTime
            : DateTime.tryParse(map['createdAt'].toString()) ?? DateTime.now())
        : DateTime.now();

    final updated = map['updatedAt'] != null
        ? (map['updatedAt'] is DateTime
            ? map['updatedAt'] as DateTime
            : DateTime.tryParse(map['updatedAt'].toString()) ?? created)
        : created;

    List<ReportStatusLog> logs = [];
    if (map['statusHistory'] != null && map['statusHistory'] is List) {
      logs = (map['statusHistory'] as List)
          .map((item) => ReportStatusLog.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } else {
      logs = [
        ReportStatusLog(
          status: map['status'] ?? 'Submitted',
          timestamp: created,
          remarks: 'Initial report submitted',
        )
      ];
    }

    return CivicReport(
      id: reportId,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      category: map['category'] ?? 'Other',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      imageUrl: map['imageUrl'],
      status: map['status'] ?? 'Submitted',
      createdAt: created,
      updatedAt: updated,
      statusHistory: logs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category,
      'description': description,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'statusHistory': statusHistory.map((e) => e.toMap()).toList(),
    };
  }

  CivicReport copyWith({
    String? status,
    DateTime? updatedAt,
    List<ReportStatusLog>? statusHistory,
  }) {
    return CivicReport(
      id: id,
      userId: userId,
      title: title,
      category: category,
      description: description,
      location: location,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      statusHistory: statusHistory ?? this.statusHistory,
    );
  }
}

class ReportStatusLog {
  final String status;
  final DateTime timestamp;
  final String remarks;

  ReportStatusLog({
    required this.status,
    required this.timestamp,
    required this.remarks,
  });

  factory ReportStatusLog.fromMap(Map<String, dynamic> map) {
    return ReportStatusLog(
      status: map['status'] ?? '',
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is DateTime
              ? map['timestamp'] as DateTime
              : DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now())
          : DateTime.now(),
      remarks: map['remarks'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'remarks': remarks,
    };
  }
}

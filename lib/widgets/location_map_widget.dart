import 'package:flutter/material.dart';
import '../models/civic_report.dart';
import '../theme/app_theme.dart';

/// Clean, public-service GIS map component for displaying civic report coordinates and sectors
class LocationMapWidget extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String locationName;
  final List<CivicReport>? reports;
  final CivicReport? selectedReport;
  final ValueChanged<CivicReport>? onSelectReport;
  final double height;

  const LocationMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.reports,
    this.selectedReport,
    this.onSelectReport,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E9EC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Realistic municipal grid pattern
            CustomPaint(
              size: Size.infinite,
              painter: _GridMapPainter(),
            ),

            // Center Pin or report markers
            if (reports != null && reports!.isNotEmpty)
              ..._buildReportMarkers(context)
            else
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppTheme.subtleShadow,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on, size: 13, color: AppColors.errorRed),
                          const SizedBox(width: 4),
                          Text(
                            locationName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(Icons.location_pin, size: 36, color: AppColors.errorRed),
                  ],
                ),
              ),

            // Top status pill
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore_outlined, size: 12, color: AppColors.primaryNavy),
                    const SizedBox(width: 4),
                    Text(
                      '${latitude.toStringAsFixed(3)}°N, ${longitude.toStringAsFixed(3)}°E',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReportMarkers(BuildContext context) {
    final list = reports!;
    final total = list.length;
    final List<Widget> widgets = [];

    for (int i = 0; i < total; i++) {
      final report = list[i];
      final isSelected = selectedReport?.id == report.id;
      final offsetFactorX = ((i * 37) % 70 + 15) / 100.0;
      final offsetFactorY = ((i * 47) % 60 + 20) / 100.0;

      widgets.add(
        Positioned(
          left: (offsetFactorX * 320).clamp(20, 280),
          top: (offsetFactorY * (height - 40)).clamp(20, height - 50),
          child: GestureDetector(
            onTap: () {
              if (onSelectReport != null) onSelectReport!(report);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      report.id,
                      style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryNavy : _getMarkerColor(report.status),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: AppTheme.subtleShadow,
                  ),
                  child: Icon(
                    _getCategoryIcon(report.category),
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  Color _getMarkerColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return AppColors.statusSubmitted;
      case 'under review':
        return AppColors.statusUnderReview;
      case 'in progress':
        return AppColors.statusInProgress;
      case 'resolved':
        return AppColors.statusResolved;
      default:
        return AppColors.statusClosed;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'street light':
        return Icons.lightbulb;
      case 'road':
        return Icons.add_road;
      case 'garbage':
        return Icons.delete;
      case 'water supply':
        return Icons.water_drop;
      default:
        return Icons.report;
    }
  }
}

class _GridMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFD6DBDF)
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final roadBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    // Grid lines
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Arterial road paths
    final path1 = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width, size.height * 0.3);

    final path2 = Path()
      ..moveTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.65, size.height);

    canvas.drawPath(path1, roadBorder);
    canvas.drawPath(path1, roadPaint);
    canvas.drawPath(path2, roadBorder);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

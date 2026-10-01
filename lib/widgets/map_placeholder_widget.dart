import 'package:flutter/material.dart';
import '../models/polling_booth.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Interactive Map Widget
///
/// Provides a realistic, offline municipal cartographic interface showing
/// polling booth pins, distance vectors, and citizen's current location without
/// requiring external API keys.
class MapPlaceholderWidget extends StatefulWidget {
  final List<PollingBooth> booths;
  final PollingBooth? selectedBooth;
  final ValueChanged<PollingBooth> onSelectBooth;
  final VoidCallback onDetailsTap;

  const MapPlaceholderWidget({
    super.key,
    required this.booths,
    this.selectedBooth,
    required this.onSelectBooth,
    required this.onDetailsTap,
  });

  @override
  State<MapPlaceholderWidget> createState() => _MapPlaceholderWidgetState();
}

class _MapPlaceholderWidgetState extends State<MapPlaceholderWidget> {
  double _zoomLevel = 1.0;
  Offset _panOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Interactive Canvas
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _panOffset += details.delta;
            });
          },
          child: Container(
            color: const Color(0xFFE9ECEF), // Realistic GIS map land tint
            width: double.infinity,
            height: double.infinity,
            child: ClipRect(
              child: Transform.translate(
                offset: _panOffset,
                child: Transform.scale(
                  scale: _zoomLevel,
                  child: CustomPaint(
                    painter: _MapCanvasPainter(
                      booths: widget.booths,
                      selectedBooth: widget.selectedBooth,
                    ),
                    child: Stack(
                      children: [
                        // Clickable booth pins overlay
                        ...widget.booths.map((booth) {
                          final point = _getScreenCoordinates(booth.latitude, booth.longitude);
                          final isSelected = widget.selectedBooth?.id == booth.id;

                          return Positioned(
                            left: point.dx - 22,
                            top: point.dy - 42,
                            child: GestureDetector(
                              onTap: () => widget.onSelectBooth(booth),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppTheme.primaryNavy : Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isSelected ? Colors.white : AppTheme.primaryNavy,
                                        width: 1.2,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      booth.boothNumber.replaceAll('Polling Booth ', 'B-').replaceAll('Booth ', 'B-'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: isSelected ? Colors.white : AppTheme.primaryNavy,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.location_on_sharp,
                                    size: isSelected ? 36 : 28,
                                    color: isSelected ? AppTheme.accentGreen : AppTheme.primaryNavy,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        // Citizen Current Position Marker with Ripple
                        Positioned(
                          left: 185,
                          top: 235,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF0284C7),
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x440284C7),
                                      blurRadius: 10,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(color: AppTheme.borderSubtle),
                                ),
                                child: const Text(
                                  'You Are Here',
                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Color(0xFF0284C7)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Map Watermark & Ward Label
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.borderSubtle),
              boxShadow: AppTheme.subtleShadow,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.layers_outlined, size: 14, color: AppTheme.primaryNavy),
                SizedBox(width: 6),
                Text(
                  'Ward 12 Municipal GIS Cartography',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ),

        // Map Control Buttons (Zoom In, Zoom Out, Recenter)
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              _mapControlBtn(
                icon: Icons.add,
                tooltip: 'Zoom In',
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel + 0.2).clamp(0.8, 2.2);
                  });
                },
              ),
              const SizedBox(height: 6),
              _mapControlBtn(
                icon: Icons.remove,
                tooltip: 'Zoom Out',
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel - 0.2).clamp(0.8, 2.2);
                  });
                },
              ),
              const SizedBox(height: 6),
              _mapControlBtn(
                icon: Icons.my_location,
                tooltip: 'Center on My Location',
                onPressed: () {
                  setState(() {
                    _zoomLevel = 1.0;
                    _panOffset = Offset.zero;
                  });
                },
              ),
            ],
          ),
        ),

        // Selected Booth Floating Bottom Card
        if (widget.selectedBooth != null)
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
                boxShadow: AppTheme.cardShadow,
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                          child: const Icon(
                            Icons.where_to_vote,
                            color: AppTheme.accentGreen,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.selectedBooth!.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.selectedBooth!.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.near_me_outlined, size: 14, color: AppTheme.accentGreen),
                            const SizedBox(width: 4),
                            Text(
                              Formatters.formatDistance(widget.selectedBooth!.distanceKm),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.accentGreen,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.selectedBooth!.wheelchairAccessible)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceMuted,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.accessible, size: 11, color: AppTheme.textSecondary),
                                    SizedBox(width: 3),
                                    Text('Accessible', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        FilledButton(
                          onPressed: widget.onDetailsTap,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('View Booth Details'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
  }

  Widget _mapControlBtn({required IconData icon, required String tooltip, required VoidCallback onPressed}) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
      elevation: 2,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            width: 34,
            height: 34,
            child: Icon(icon, size: 18, color: AppTheme.primaryNavy),
          ),
        ),
      ),
    );
  }

  Offset _getScreenCoordinates(double lat, double lon) {
    const minLat = 19.050;
    const maxLat = 19.100;
    const minLon = 72.850;
    const maxLon = 72.905;

    final xNorm = (lon - minLon) / (maxLon - minLon);
    final yNorm = 1.0 - ((lat - minLat) / (maxLat - minLat));

    return Offset(xNorm * 380 + 20, yNorm * 460 + 20);
  }
}

/// Custom painter rendering realistic municipal roads, ward boundary, and landmarks
class _MapCanvasPainter extends CustomPainter {
  final List<PollingBooth> booths;
  final PollingBooth? selectedBooth;

  _MapCanvasPainter({
    required this.booths,
    this.selectedBooth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    final parkPaint = Paint()
      ..color = const Color(0xFFD1E7DD)
      ..style = PaintingStyle.fill;

    final waterPaint = Paint()
      ..color = const Color(0xFFC7DDF8)
      ..style = PaintingStyle.fill;

    // Draw municipal park area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(35, 65, 120, 90),
        const Radius.circular(8),
      ),
      parkPaint,
    );

    // Draw civic water canal
    final canalPath = Path();
    canalPath.moveTo(0, 360);
    canalPath.cubicTo(100, 370, 240, 340, 420, 390);
    canvas.drawPath(
      canalPath,
      Paint()
        ..color = waterPaint.color
        ..strokeWidth = 18
        ..style = PaintingStyle.stroke,
    );

    // Major Arterial Roads
    final mainRoad1 = Path();
    mainRoad1.moveTo(0, 160);
    mainRoad1.lineTo(400, 160);
    canvas.drawPath(mainRoad1, roadPaint);

    final mainRoad2 = Path();
    mainRoad2.moveTo(200, 0);
    mainRoad2.lineTo(200, 500);
    canvas.drawPath(mainRoad2, roadPaint);

    final diagRoad = Path();
    diagRoad.moveTo(30, 400);
    diagRoad.lineTo(360, 60);
    canvas.drawPath(diagRoad, roadPaint);

    // Minor local roads
    for (int y = 60; y < 480; y += 70) {
      canvas.drawLine(Offset(20, y.toDouble()), Offset(380, y.toDouble()), minorRoadPaint);
    }
    for (int x = 50; x < 380; x += 65) {
      canvas.drawLine(Offset(x.toDouble(), 20), Offset(x.toDouble(), 480), minorRoadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapCanvasPainter oldDelegate) => true;
}

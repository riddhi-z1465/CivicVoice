import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Official CivicVoice brand mark and emblem.
///
/// Symbolism:
/// 1. The Civic Rotunda & Colonnade: Public institutional integrity and community governance.
/// 2. The Acoustic Voice Waves: Citizens' voices resonating throughout the municipal framework.
/// 3. The Resolution Checkmark: Democratic accountability and tangible grievance resolution.
/// 4. The Golden Civic Beacon: The spark of community empowerment and civic progress.
class CivicLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final String? subtitle;
  final bool isLight;
  final VoidCallback? onTap;
  final Axis orientation;

  const CivicLogo({
    super.key,
    this.size = 48,
    this.showText = false,
    this.subtitle,
    this.isLight = false,
    this.onTap,
    this.orientation = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    // Squircle emblem badge with tactile glassmorphism sheen and ambient glow
    Widget emblem = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLight
              ? [
                  Colors.white,
                  const Color(0xFFF0FDF4),
                  const Color(0xFFE6F4F1),
                ]
              : [
                  const Color(0xFF227878), // Vibrant upper teal
                  const Color(0xFF165A5A), // Rich civic teal
                  const Color(0xFF0C3838), // Deep foundation slate
                ],
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(
          color: isLight
              ? AppColors.borderMedium.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.22),
          width: math.max(1.0, size * 0.024),
        ),
        boxShadow: [
          BoxShadow(
            color: (isLight
                    ? const Color(0xFF0F3E3E)
                    : const Color(0xFF062222))
                .withValues(alpha: isLight ? 0.08 : 0.22),
            blurRadius: size * 0.28,
            offset: Offset(0, size * 0.08),
            spreadRadius: -size * 0.02,
          ),
          if (!isLight)
            BoxShadow(
              color: const Color(0xFF5EEAD4).withValues(alpha: 0.12),
              blurRadius: size * 0.40,
              offset: const Offset(0, 0),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: Stack(
          children: [
            // Top specular glass highlight
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: size * 0.44,
              child: CustomPaint(
                painter: _GlassSheenPainter(isLight: isLight),
              ),
            ),
            // Core vector emblem mark
            CustomPaint(
              size: Size(size, size),
              painter: _CivicEmblemPainter(isLight: isLight),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      emblem = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size * 0.25),
        child: emblem,
      );
    }

    if (!showText) {
      return emblem;
    }

    final titleStyle = TextStyle(
      fontSize: math.max(16.0, size * 0.40),
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
      height: 1.15,
    );

    final titleWidget = RichText(
      textAlign: orientation == Axis.vertical ? TextAlign.center : TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Civic',
            style: titleStyle.copyWith(
              color: isLight ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'Voice',
            style: titleStyle.copyWith(
              color: isLight
                  ? const Color(0xFF5EEAD4)
                  : const Color(0xFF185E5E),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );

    final subtitleWidget = (subtitle != null && subtitle!.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              subtitle!,
              textAlign: orientation == Axis.vertical ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontSize: math.max(11.0, size * 0.19),
                fontWeight: FontWeight.w500,
                color: isLight
                    ? const Color(0xB3FFFFFF)
                    : AppColors.textMuted,
                letterSpacing: -0.15,
                height: 1.25,
              ),
            ),
          )
        : null;

    if (orientation == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emblem,
          SizedBox(width: size * 0.26),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              ?subtitleWidget,
            ],
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        emblem,
        SizedBox(height: size * 0.22),
        titleWidget,
        ?subtitleWidget,
      ],
    );
  }
}

/// Subtle curved glass reflection across the upper quadrant
class _GlassSheenPainter extends CustomPainter {
  final bool isLight;
  _GlassSheenPainter({required this.isLight});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sheenPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h * 0.70)
      ..quadraticBezierTo(w * 0.5, h * 1.15, 0, h * 0.60)
      ..close();

    final sheenPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          (isLight ? Colors.white : Colors.white).withValues(alpha: isLight ? 0.28 : 0.15),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(sheenPath, sheenPaint);
  }

  @override
  bool shouldRepaint(covariant _GlassSheenPainter oldDelegate) =>
      oldDelegate.isLight != isLight;
}

/// High-precision vector painter rendering the official CivicVoice brand mark:
/// Capitol Rotunda Dome + Symmetrical Acoustic Voice Waves + Heroic Resolution Checkmark + Golden Beacon
class _CivicEmblemPainter extends CustomPainter {
  final bool isLight;

  _CivicEmblemPainter({required this.isLight});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Palette tokens
    final domeColor = isLight ? const Color(0xFF185E5E) : Colors.white;
    final voiceWaveColor = isLight ? const Color(0xFF266E64) : const Color(0xFF5EEAD4);
    final beaconColor = const Color(0xFFF59E0B); // Amber / Gold civic beacon
    final checkmarkGlowColor = isLight
        ? const Color(0xFF185E5E).withValues(alpha: 0.15)
        : const Color(0xFF052020).withValues(alpha: 0.45);

    // =========================================================================
    // 1. ACOUSTIC VOICE RESONANCE WAVES (Radiating outward from civic center)
    // =========================================================================
    final waveCenter = Offset(w * 0.50, h * 0.46);

    // Left Voice Waves
    _drawVoiceArc(
      canvas: canvas,
      center: waveCenter,
      radius: w * 0.29,
      startAngle: math.pi * 0.76,
      sweepAngle: math.pi * 0.48,
      strokeWidth: math.max(1.6, w * 0.046),
      color: voiceWaveColor.withValues(alpha: isLight ? 0.90 : 0.95),
    );
    _drawVoiceArc(
      canvas: canvas,
      center: waveCenter,
      radius: w * 0.38,
      startAngle: math.pi * 0.79,
      sweepAngle: math.pi * 0.42,
      strokeWidth: math.max(1.3, w * 0.038),
      color: voiceWaveColor.withValues(alpha: isLight ? 0.65 : 0.70),
    );
    _drawVoiceArc(
      canvas: canvas,
      center: waveCenter,
      radius: w * 0.46,
      startAngle: math.pi * 0.83,
      sweepAngle: math.pi * 0.34,
      strokeWidth: math.max(1.1, w * 0.030),
      color: voiceWaveColor.withValues(alpha: isLight ? 0.35 : 0.40),
    );

    // Right Voice Waves
    _drawVoiceArc(
      canvas: canvas,
      center: waveCenter,
      radius: w * 0.29,
      startAngle: -math.pi * 0.24,
      sweepAngle: math.pi * 0.48,
      strokeWidth: math.max(1.6, w * 0.046),
      color: voiceWaveColor.withValues(alpha: isLight ? 0.90 : 0.95),
    );
    _drawVoiceArc(
      canvas: canvas,
      center: waveCenter,
      radius: w * 0.38,
      startAngle: -math.pi * 0.21,
      sweepAngle: math.pi * 0.42,
      strokeWidth: math.max(1.3, w * 0.038),
      color: voiceWaveColor.withValues(alpha: isLight ? 0.65 : 0.70),
    );
    _drawVoiceArc(
      canvas: canvas,
      center: waveCenter,
      radius: w * 0.46,
      startAngle: -math.pi * 0.17,
      sweepAngle: math.pi * 0.34,
      strokeWidth: math.max(1.1, w * 0.030),
      color: voiceWaveColor.withValues(alpha: isLight ? 0.35 : 0.40),
    );

    // =========================================================================
    // 2. CIVIC FOUNDATION & COLONNADE (Democracy / Municipal Architecture)
    // =========================================================================
    final domePaint = Paint()
      ..color = domeColor
      ..style = PaintingStyle.fill;

    // A. Civic Plinth / Base Foundation Step (Rounded modern pedestal)
    final plinthRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.25, h * 0.74, w * 0.50, h * 0.055),
      Radius.circular(w * 0.026),
    );
    canvas.drawRRect(plinthRect, domePaint);

    // Secondary upper stepped plinth
    final stepRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.30, h * 0.69, w * 0.40, h * 0.040),
      Radius.circular(w * 0.018),
    );
    canvas.drawRRect(stepRect, domePaint);

    // B. Architectural Columns (Colonnade of the People)
    final columnWidth = w * 0.050;
    final columnHeight = h * 0.125;
    final columnTop = h * 0.555;
    final columnRadius = Radius.circular(w * 0.022);

    final columnXPositions = [
      w * 0.33, // Left outer column
      w * 0.43, // Left inner column
      w * 0.52, // Right inner column
      w * 0.62, // Right outer column
    ];

    for (final colX in columnXPositions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(colX, columnTop, columnWidth, columnHeight),
          columnRadius,
        ),
        domePaint,
      );
    }

    // C. Entablature / Architrave (Beam over columns)
    final entablatureRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.29, h * 0.515, w * 0.42, h * 0.036),
      Radius.circular(w * 0.016),
    );
    canvas.drawRRect(entablatureRect, domePaint);

    // =========================================================================
    // 3. THE CAPITOL DOME / CIVIC ARCH
    // =========================================================================
    final domePath = Path()
      ..moveTo(w * 0.31, h * 0.515)
      ..cubicTo(
        w * 0.31,
        h * 0.360,
        w * 0.40,
        h * 0.305,
        w * 0.50,
        h * 0.305,
      )
      ..cubicTo(
        w * 0.60,
        h * 0.305,
        w * 0.69,
        h * 0.360,
        w * 0.69,
        h * 0.515,
      )
      ..close();

    final domeFillPaint = Paint()
      ..color = domeColor.withValues(alpha: isLight ? 0.95 : 0.92)
      ..style = PaintingStyle.fill;
    canvas.drawPath(domePath, domeFillPaint);

    // Dome architectural fluting / ribs (Subtle negative space grooves)
    final ribPaint = Paint()
      ..color = (isLight ? Colors.white : const Color(0xFF165A5A)).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, w * 0.024)
      ..strokeCap = StrokeCap.round;

    // Center rib
    canvas.drawLine(
      Offset(w * 0.50, h * 0.31),
      Offset(w * 0.50, h * 0.51),
      ribPaint,
    );
    // Left rib
    canvas.drawLine(
      Offset(w * 0.42, h * 0.345),
      Offset(w * 0.39, h * 0.51),
      ribPaint,
    );
    // Right rib
    canvas.drawLine(
      Offset(w * 0.58, h * 0.345),
      Offset(w * 0.61, h * 0.51),
      ribPaint,
    );

    // =========================================================================
    // 4. THE GOLDEN CIVIC BEACON (Apex of public empowerment)
    // =========================================================================
    // Lantern base
    final lanternRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.47, h * 0.255, w * 0.06, h * 0.05),
      Radius.circular(w * 0.012),
    );
    canvas.drawRRect(lanternRect, domePaint);

    // Beacon finial sphere with radiant glow
    final beaconGlowPaint = Paint()
      ..color = beaconColor.withValues(alpha: 0.35)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, math.max(1.5, w * 0.04));
    canvas.drawCircle(Offset(w * 0.50, h * 0.23), w * 0.045, beaconGlowPaint);

    final beaconPaint = Paint()
      ..color = beaconColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.50, h * 0.23), math.max(1.8, w * 0.032), beaconPaint);

    // =========================================================================
    // 5. HEROIC CIVIC RESOLUTION CHECKMARK (Citizen Action & Trust)
    // =========================================================================
    // Checkmark coordinates: ascending with forward democratic momentum
    final checkPath = Path()
      ..moveTo(w * 0.39, h * 0.585)
      ..lineTo(w * 0.485, h * 0.675)
      ..lineTo(w * 0.655, h * 0.435);

    // Soft drop shadow behind checkmark for strong contrast over the colonnade
    final checkShadowPaint = Paint()
      ..color = checkmarkGlowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.8, w * 0.088)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(checkPath, checkShadowPaint);

    // Foreground checkmark: Vibrant Mint gradient or Pure White
    final checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.2, w * 0.068)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    if (isLight) {
      checkPaint.color = const Color(0xFF185E5E);
    } else {
      checkPaint.shader = LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          const Color(0xFFFFFFFF),
          const Color(0xFF6EE7B7),
          const Color(0xFF5EEAD4),
        ],
      ).createShader(Rect.fromLTWH(w * 0.38, h * 0.42, w * 0.30, h * 0.30));
    }

    canvas.drawPath(checkPath, checkPaint);
  }

  void _drawVoiceArc({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required double strokeWidth,
    required Color color,
  }) {
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CivicEmblemPainter oldDelegate) {
    return oldDelegate.isLight != isLight;
  }
}


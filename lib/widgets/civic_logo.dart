import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Official CivicVoice emblem combining the democratic ballot, civic institution arch,
/// and citizen voice waves into a unified, authentic public-service identity.
class CivicLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final String? subtitle;
  final bool isLight;
  final VoidCallback? onTap;

  const CivicLogo({
    super.key,
    this.size = 48,
    this.showText = false,
    this.subtitle,
    this.isLight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget emblem = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLight
              ? [Colors.white, const Color(0xFFF1F5F5)]
              : [
                  AppColors.primaryNavyLight,
                  AppColors.primaryNavy,
                  AppColors.primaryNavyDark,
                ],
        ),
        borderRadius: BorderRadius.circular(size * 0.24),
        border: Border.all(
          color: isLight ? AppColors.borderMedium : const Color(0x33FFFFFF),
          width: math.max(1.0, size * 0.025),
        ),
        boxShadow: [
          BoxShadow(
            color: (isLight ? Colors.black : AppColors.primaryNavyDark).withValues(alpha: 0.12),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.23),
        child: CustomPaint(
          size: Size(size, size),
          painter: _CivicEmblemPainter(isLight: isLight),
        ),
      ),
    );

    if (onTap != null) {
      emblem = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size * 0.24),
        child: emblem,
      );
    }

    if (!showText) {
      return emblem;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        emblem,
        SizedBox(height: size * 0.22),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Civic',
                style: TextStyle(
                  fontSize: math.max(16.0, size * 0.42),
                  fontWeight: FontWeight.w800,
                  color: isLight ? Colors.white : AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'Voice',
                style: TextStyle(
                  fontSize: math.max(16.0, size * 0.42),
                  fontWeight: FontWeight.w800,
                  color: isLight ? const Color(0xFF80CBC4) : AppColors.primaryNavy,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: math.max(11.0, size * 0.2),
              fontWeight: FontWeight.w500,
              color: isLight ? const Color(0xCCFFFFFF) : AppColors.textMuted,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ],
    );
  }
}

/// Custom vector painter rendering the official CivicVoice civic seal
class _CivicEmblemPainter extends CustomPainter {
  final bool isLight;

  _CivicEmblemPainter({required this.isLight});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final primaryColor = isLight ? AppColors.primaryNavy : Colors.white;
    final accentColor = isLight ? AppColors.secondaryTeal : const Color(0xFF80CBC4); // Mint/teal accent
    final slotColor = isLight ? AppColors.primaryNavyDark : const Color(0xFF0F3E3E);

    // 1. Decorative Subtle Civic Arch / Halo at the top
    final archPaint = Paint()
      ..color = accentColor.withValues(alpha: isLight ? 0.25 : 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, w * 0.035)
      ..strokeCap = StrokeCap.round;

    final archPath = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(w * 0.5, h * 0.52), radius: w * 0.36),
        -math.pi * 0.85,
        math.pi * 0.70,
      );
    canvas.drawPath(archPath, archPaint);

    // 2. The Civic Ballot Box (Institutional Foundation)
    final boxPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, w * 0.055)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Outer ballot receptacle contour
    final boxPath = Path()
      ..moveTo(w * 0.22, h * 0.58)
      ..lineTo(w * 0.28, h * 0.81)
      ..arcToPoint(
        Offset(w * 0.32, h * 0.83),
        radius: Radius.circular(w * 0.04),
        clockwise: false,
      )
      ..lineTo(w * 0.68, h * 0.83)
      ..arcToPoint(
        Offset(w * 0.72, h * 0.81),
        radius: Radius.circular(w * 0.04),
        clockwise: false,
      )
      ..lineTo(w * 0.78, h * 0.58)
      ..close();

    canvas.drawPath(boxPath, boxPaint);

    // Box top intake slot rim
    final slotPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, w * 0.055)
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(w * 0.18, h * 0.58), Offset(w * 0.82, h * 0.58), slotPaint);

    // Interior slot depth
    final slotDepthPaint = Paint()
      ..color = slotColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, w * 0.035)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.34, h * 0.58), Offset(w * 0.66, h * 0.58), slotDepthPaint);

    // 3. The Vote / Ballot Card (Citizen Input)
    final ballotFill = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final ballotRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.30, w * 0.30, h * 0.26),
      Radius.circular(w * 0.04),
    );
    canvas.drawRRect(ballotRect, ballotFill);

    // Checkmark on ballot card (Representing civic choice / franchise)
    final checkPaint = Paint()
      ..color = isLight ? Colors.white : AppColors.primaryNavy
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.8, w * 0.055)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final checkPath = Path()
      ..moveTo(w * 0.42, h * 0.42)
      ..lineTo(w * 0.48, h * 0.48)
      ..lineTo(w * 0.58, h * 0.37);
    canvas.drawPath(checkPath, checkPaint);

    // 4. Harmonic Voice Waves (Citizen Voice reaching the institution)
    final wavePaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // First acoustic wave
    wavePaint.strokeWidth = math.max(1.5, w * 0.045);
    final wave1 = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(w * 0.50, h * 0.35), radius: w * 0.20),
        -math.pi * 0.45,
        math.pi * 0.32,
      );
    canvas.drawPath(wave1, wavePaint);

    // Second acoustic wave
    wavePaint.strokeWidth = math.max(1.8, w * 0.05);
    final wave2 = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(w * 0.50, h * 0.35), radius: w * 0.30),
        -math.pi * 0.42,
        math.pi * 0.28,
      );
    canvas.drawPath(wave2, wavePaint);

    // Third acoustic wave (Subtle outer pulse)
    wavePaint.strokeWidth = math.max(1.4, w * 0.038);
    wavePaint.color = accentColor.withValues(alpha: 0.7);
    final wave3 = Path()
      ..addArc(
        Rect.fromCircle(center: Offset(w * 0.50, h * 0.35), radius: w * 0.39),
        -math.pi * 0.39,
        math.pi * 0.24,
      );
    canvas.drawPath(wave3, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _CivicEmblemPainter oldDelegate) {
    return oldDelegate.isLight != isLight;
  }
}

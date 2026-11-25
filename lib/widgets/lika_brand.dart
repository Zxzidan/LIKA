import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom-painted LIKA logo matching the green-yellow-orange ribbon/leaf mark in Figma.
class LikaLogoMark extends StatelessWidget {
  final double size;

  const LikaLogoMark({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LikaLogoPainter(),
      ),
    );
  }
}

class _LikaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Left & bottom green leaf/L-swoosh
    final greenPath = Path()
      ..moveTo(w * 0.14, h * 0.35)
      ..quadraticBezierTo(w * 0.12, h * 0.78, w * 0.36, h * 0.85)
      ..quadraticBezierTo(w * 0.54, h * 0.88, w * 0.62, h * 0.74)
      ..quadraticBezierTo(w * 0.42, h * 0.74, w * 0.35, h * 0.56)
      ..quadraticBezierTo(w * 0.28, h * 0.42, w * 0.14, h * 0.35)
      ..close();

    final greenPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF14532D), Color(0xFF16A34A), Color(0xFF84CC16)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(greenPath, greenPaint);

    // 2. Top sweeping green-to-yellow wing/ribbon
    final topWingPath = Path()
      ..moveTo(w * 0.26, h * 0.48)
      ..quadraticBezierTo(w * 0.36, h * 0.14, w * 0.88, h * 0.14)
      ..quadraticBezierTo(w * 0.76, h * 0.34, w * 0.52, h * 0.36)
      ..quadraticBezierTo(w * 0.38, h * 0.38, w * 0.32, h * 0.58)
      ..close();

    final topWingPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF15803D), Color(0xFF65A30D), Color(0xFFFACC15)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(topWingPath, topWingPaint);

    // 3. Center-right yellow-to-orange inner flame/ribbon
    final orangeWingPath = Path()
      ..moveTo(w * 0.46, h * 0.52)
      ..quadraticBezierTo(w * 0.58, h * 0.38, w * 0.80, h * 0.40)
      ..quadraticBezierTo(w * 0.70, h * 0.56, w * 0.56, h * 0.58)
      ..quadraticBezierTo(w * 0.66, h * 0.72, w * 0.56, h * 0.88)
      ..quadraticBezierTo(w * 0.44, h * 0.72, w * 0.46, h * 0.52)
      ..close();

    final orangePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFACC15), Color(0xFFF59E0B), Color(0xFFEA580C)],
        begin: Alignment.topRight,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(orangeWingPath, orangePaint);

    // 4. Small top-left accent leaf
    final leafPath = Path()
      ..moveTo(w * 0.28, h * 0.10)
      ..quadraticBezierTo(w * 0.42, h * 0.06, w * 0.46, h * 0.18)
      ..quadraticBezierTo(w * 0.32, h * 0.22, w * 0.28, h * 0.10)
      ..close();

    final leafPaint = Paint()
      ..color = const Color(0xFF4ADE80).withValues(alpha: 0.9);
    canvas.drawPath(leafPath, leafPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Emerald-to-lime green gradient background with subtle floating leaves & apples.
class LikaGreenBackground extends StatelessWidget {
  final Widget child;
  final bool darkTop;

  const LikaGreenBackground({
    super.key,
    required this.child,
    this.darkTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: darkTop
              ? const [
                  Color(0xFF0A3D17),
                  Color(0xFF15803D),
                  Color(0xFF22C55E),
                  Color(0xFF4ADE80),
                ]
              : const [
                  Color(0xFF4ADE80),
                  Color(0xFF22C55E),
                  Color(0xFF16A34A),
                  Color(0xFF14532D),
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Decorative curved highlight arc
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            left: -70,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Subtle floating leaves & apples
          _bgLeaf(top: 55, left: 26, angle: -0.4, size: 34, opacity: 0.14),
          _bgLeaf(top: 110, right: 32, angle: 0.6, size: 42, opacity: 0.12),
          _bgApple(top: 190, left: 18, size: 46, opacity: 0.10),
          _bgApple(top: 230, right: 20, size: 38, opacity: 0.12),
          _bgLeaf(bottom: 180, left: 30, angle: 0.8, size: 44, opacity: 0.14),
          _bgApple(bottom: 110, left: 48, size: 52, opacity: 0.12),
          _bgApple(bottom: 140, right: 28, size: 44, opacity: 0.14),
          _bgLeaf(bottom: 60, right: 65, angle: -0.5, size: 32, opacity: 0.12),

          // Foreground content
          child,
        ],
      ),
    );
  }

  Widget _bgLeaf({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double angle,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Icon(
          Icons.eco_rounded,
          size: size,
          color: Colors.white.withValues(alpha: opacity),
        ),
      ),
    );
  }

  Widget _bgApple({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Icon(
        Icons.apple_rounded,
        size: size,
        color: const Color(0xFFDCFCE7).withValues(alpha: opacity),
      ),
    );
  }
}

/// Cute Green Apple Mascot illustration for Onboarding slides.
class LikaAppleMascot extends StatelessWidget {
  final int slideIndex;

  const LikaAppleMascot({super.key, required this.slideIndex});

  @override
  Widget build(BuildContext context) {
    final badgeData = _getSlideBadge(slideIndex);

    return SizedBox(
      width: 240,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow behind mascot
          Container(
            width: 175,
            height: 175,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDCFCE7).withValues(alpha: 0.35),
                  blurRadius: 30,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),

          // Ground shadow
          Positioned(
            bottom: 16,
            child: Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF14532D).withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Mascot Apple Body
          CustomPaint(
            size: const Size(150, 155),
            painter: _AppleMascotPainter(),
          ),

          // Surrounding floating thematic badges matching each onboarding slide
          Positioned(
            top: 12,
            left: 16,
            child: _floatingIconBadge(
              icon: badgeData['topLeftIcon'] as IconData,
              color: badgeData['topLeftColor'] as Color,
            ),
          ),
          Positioned(
            top: 22,
            right: 12,
            child: _floatingIconBadge(
              icon: badgeData['topRightIcon'] as IconData,
              color: badgeData['topRightColor'] as Color,
            ),
          ),
          Positioned(
            bottom: 34,
            left: 8,
            child: _floatingIconBadge(
              icon: badgeData['bottomLeftIcon'] as IconData,
              color: badgeData['bottomLeftColor'] as Color,
            ),
          ),
          Positioned(
            bottom: 30,
            right: 14,
            child: _floatingIconBadge(
              icon: badgeData['bottomRightIcon'] as IconData,
              color: badgeData['bottomRightColor'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingIconBadge({required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Map<String, dynamic> _getSlideBadge(int index) {
    switch (index) {
      case 0: // Layanan Interaktif Komunitas Agro
        return {
          'topLeftIcon': Icons.forum_rounded,
          'topLeftColor': const Color(0xFF0284C7),
          'topRightIcon': Icons.headset_mic_rounded,
          'topRightColor': const Color(0xFF15803D),
          'bottomLeftIcon': Icons.people_alt_rounded,
          'bottomLeftColor': const Color(0xFFEA580C),
          'bottomRightIcon': Icons.eco_rounded,
          'bottomRightColor': const Color(0xFF16A34A),
        };
      case 1: // Memberdayakan UMKM Lokal
        return {
          'topLeftIcon': Icons.storefront_rounded,
          'topLeftColor': const Color(0xFF0D9488),
          'topRightIcon': Icons.trending_up_rounded,
          'topRightColor': const Color(0xFF15803D),
          'bottomLeftIcon': Icons.shopping_basket_rounded,
          'bottomLeftColor': const Color(0xFFD97706),
          'bottomRightIcon': Icons.verified_rounded,
          'bottomRightColor': const Color(0xFF0284C7),
        };
      case 2: // Dari Kebun Ke Genggaman Anda
        return {
          'topLeftIcon': Icons.local_shipping_rounded,
          'topLeftColor': const Color(0xFF15803D),
          'topRightIcon': Icons.agriculture_rounded,
          'topRightColor': const Color(0xFFEA580C),
          'bottomLeftIcon': Icons.delivery_dining_rounded,
          'bottomLeftColor': const Color(0xFF0284C7),
          'bottomRightIcon': Icons.inventory_2_rounded,
          'bottomRightColor': const Color(0xFFD97706),
        };
      case 3: // Wisata Cerdas, Mudah Dipesan
        return {
          'topLeftIcon': Icons.map_rounded,
          'topLeftColor': const Color(0xFF0284C7),
          'topRightIcon': Icons.confirmation_number_rounded,
          'topRightColor': const Color(0xFFEA580C),
          'bottomLeftIcon': Icons.camera_alt_rounded,
          'bottomLeftColor': const Color(0xFFDB2777),
          'bottomRightIcon': Icons.location_on_rounded,
          'bottomRightColor': const Color(0xFF15803D),
        };
      case 4: // Belanja, Wisata, dan Bermain
      default:
        return {
          'topLeftIcon': Icons.sports_esports_rounded,
          'topLeftColor': const Color(0xFF7C3AED),
          'topRightIcon': Icons.shopping_bag_rounded,
          'topRightColor': const Color(0xFFEA580C),
          'bottomLeftIcon': Icons.stars_rounded,
          'bottomLeftColor': const Color(0xFFEAB308),
          'bottomRightIcon': Icons.park_rounded,
          'bottomRightColor': const Color(0xFF15803D),
        };
    }
  }
}

class _AppleMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Stem
    final stemPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, h * 0.24), Offset(cx + 4, h * 0.08), stemPaint);

    // Leaf on top
    final leafPath = Path()
      ..moveTo(cx + 3, h * 0.14)
      ..quadraticBezierTo(cx + 28, h * 0.02, cx + 32, h * 0.18)
      ..quadraticBezierTo(cx + 15, h * 0.24, cx + 3, h * 0.14)
      ..close();
    canvas.drawPath(leafPath, Paint()..color = const Color(0xFF15803D));

    // Apple Body
    final bodyPath = Path()
      ..moveTo(cx, h * 0.26)
      ..cubicTo(w * 0.22, h * 0.16, w * 0.06, h * 0.42, w * 0.14, h * 0.70)
      ..cubicTo(w * 0.22, h * 0.94, w * 0.44, h * 0.94, cx, h * 0.88)
      ..cubicTo(w * 0.56, h * 0.94, w * 0.78, h * 0.94, w * 0.86, h * 0.70)
      ..cubicTo(w * 0.94, h * 0.42, w * 0.78, h * 0.16, cx, h * 0.26)
      ..close();

    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFBEF264), Color(0xFF84CC16), Color(0xFF16A34A)],
        center: Alignment(-0.25, -0.35),
        radius: 0.9,
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(bodyPath, bodyPaint);

    // Gloss highlight
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.30, h * 0.38), width: 16, height: 26),
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );

    // Headphones Band
    final bandPaint = Paint()
      ..color = const Color(0xFF1F2937)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, h * 0.46), width: w * 0.86, height: h * 0.62),
      math.pi * 1.05,
      math.pi * 0.9,
      false,
      bandPaint,
    );

    // Ear cups
    final earPaint = Paint()..color = const Color(0xFF111827);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.04, h * 0.42, 14, 28), const Radius.circular(8)),
      earPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.86, h * 0.42, 14, 28), const Radius.circular(8)),
      earPaint,
    );

    // Cute Eyes
    final eyeWhite = Paint()..color = Colors.white;
    final eyePupil = Paint()..color = const Color(0xFF111827);
    canvas.drawCircle(Offset(w * 0.38, h * 0.50), 9.5, eyeWhite);
    canvas.drawCircle(Offset(w * 0.62, h * 0.50), 9.5, eyeWhite);
    canvas.drawCircle(Offset(w * 0.39, h * 0.50), 5.5, eyePupil);
    canvas.drawCircle(Offset(w * 0.61, h * 0.50), 5.5, eyePupil);
    canvas.drawCircle(Offset(w * 0.41, h * 0.48), 2.2, eyeWhite);
    canvas.drawCircle(Offset(w * 0.63, h * 0.48), 2.2, eyeWhite);

    // Rosy Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFB7185).withValues(alpha: 0.55);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.28, h * 0.59), width: 14, height: 8), cheekPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.72, h * 0.59), width: 14, height: 8), cheekPaint);

    // Big Happy Smile
    final mouthPath = Path()
      ..moveTo(w * 0.40, h * 0.62)
      ..quadraticBezierTo(cx, h * 0.76, w * 0.60, h * 0.62)
      ..close();
    canvas.drawPath(mouthPath, Paint()..color = const Color(0xFF991B1B));

    // Tongue
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, h * 0.67), width: 12, height: 6),
      Paint()..color = const Color(0xFFFB7185),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

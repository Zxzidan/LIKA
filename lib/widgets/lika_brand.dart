import 'package:flutter/material.dart';

/// Official LIKA logo exported from Figma (`lika_logo.png` includes white "LIKA" wordmark
/// for dark/green backgrounds; `lika_icon.png` renders only the ribbon mark for light backgrounds).
class LikaLogoMark extends StatelessWidget {
  final double size;
  final bool includeText;

  const LikaLogoMark({
    super.key,
    this.size = 90,
    this.includeText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      includeText
          ? 'assets/images/lika_logo.png'
          : 'assets/images/lika_icon.png',
      width: includeText ? size : size * 1.15,
      height: includeText ? size : null,
      fit: BoxFit.contain,
    );
  }
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
          Positioned.fill(child: child),
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

/// Official Apple Mascot illustration for each Onboarding slide exported from Figma.
class LikaAppleMascot extends StatelessWidget {
  final int slideIndex;

  const LikaAppleMascot({super.key, required this.slideIndex});

  static const List<String> _slideAssets = [
    'assets/images/onboarding_1.png',
    'assets/images/onboarding_2.png',
    'assets/images/onboarding_3.png',
    'assets/images/onboarding_4.png',
    'assets/images/onboarding_5.png',
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = slideIndex.clamp(0, _slideAssets.length - 1);

    return SizedBox(
      width: 300,
      height: 245,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDCFCE7).withValues(alpha: 0.28),
                  blurRadius: 34,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),
          Image.asset(
            _slideAssets[safeIndex],
            width: 295,
            height: 240,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

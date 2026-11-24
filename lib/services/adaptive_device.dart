import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'user_agent.dart';

class AdaptivePlatform {
  static final ValueNotifier<TargetPlatform> platformNotifier =
      ValueNotifier<TargetPlatform>(_detectPlatform());

  static TargetPlatform _detectPlatform() {
    final ua = getUserAgent().toLowerCase();
    if (ua.contains('iphone') || ua.contains('ipad') || ua.contains('ipod')) {
      return TargetPlatform.iOS;
    } else if (ua.contains('android')) {
      return TargetPlatform.android;
    }
    // Default fallback
    if (!kIsWeb) {
      return defaultTargetPlatform;
    }
    return TargetPlatform.iOS;
  }

  static TargetPlatform get current => platformNotifier.value;

  static bool get isIOS => platformNotifier.value == TargetPlatform.iOS;
  static bool get isAndroid => platformNotifier.value == TargetPlatform.android;

  static void setPlatform(TargetPlatform platform) {
    platformNotifier.value = platform;
  }

  static void toggle() {
    if (platformNotifier.value == TargetPlatform.iOS) {
      platformNotifier.value = TargetPlatform.android;
    } else {
      platformNotifier.value = TargetPlatform.iOS;
    }
  }
}

/// Adaptive Status Bar Widget (iOS vs Android)
class AdaptiveStatusBar extends StatelessWidget {
  final Color contentColor;
  final bool showTime;

  const AdaptiveStatusBar({
    super.key,
    this.contentColor = const Color(0xFF111827),
    this.showTime = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TargetPlatform>(
      valueListenable: AdaptivePlatform.platformNotifier,
      builder: (context, platform, child) {
        final isIOS = platform == TargetPlatform.iOS;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Time & Device Identifier
              if (showTime)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isIOS ? '9:41' : '10:00',
                      style: TextStyle(
                        fontSize: isIOS ? 14 : 13,
                        fontWeight: isIOS ? FontWeight.w800 : FontWeight.w600,
                        color: contentColor,
                        letterSpacing: isIOS ? -0.3 : 0.0,
                        fontFamily: isIOS ? 'SF Pro Text' : 'Roboto',
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: contentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isIOS ? 'iOS' : 'Android',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: contentColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                )
              else
                const SizedBox(),

              // Right: Signal, Wifi, Battery
              if (isIOS)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // iOS Cellular Signal (4 bars)
                    Icon(Icons.signal_cellular_alt_rounded, size: 16, color: contentColor),
                    const SizedBox(width: 4),
                    // iOS Wifi
                    Icon(Icons.wifi_rounded, size: 16, color: contentColor),
                    const SizedBox(width: 5),
                    // iOS Battery Capsule
                    Container(
                      width: 22,
                      height: 11,
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        border: Border.all(color: contentColor, width: 1.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: contentColor,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '95%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: contentColor),
                    ),
                    const SizedBox(width: 4),
                    // Android Battery
                    Icon(Icons.battery_full_rounded, size: 16, color: contentColor),
                    const SizedBox(width: 4),
                    // Android Wifi
                    Icon(Icons.wifi_rounded, size: 15, color: contentColor),
                    const SizedBox(width: 4),
                    // Android Signal Triangle
                    Icon(Icons.signal_cellular_4_bar_rounded, size: 15, color: contentColor),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Adaptive Bottom Home Indicator (iOS Home Bar vs Android Gesture Line)
class AdaptiveHomeIndicator extends StatelessWidget {
  final Color color;

  const AdaptiveHomeIndicator({
    super.key,
    this.color = const Color(0xFF111827),
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TargetPlatform>(
      valueListenable: AdaptivePlatform.platformNotifier,
      builder: (context, platform, child) {
        final isIOS = platform == TargetPlatform.iOS;

        return Padding(
          padding: EdgeInsets.only(top: 6, bottom: isIOS ? 8.0 : 4.0),
          child: Center(
            child: Container(
              width: isIOS ? 134 : 72,
              height: isIOS ? 4.5 : 3.5,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isIOS ? 0.8 : 0.6),
                borderRadius: BorderRadius.circular(isIOS ? 3 : 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Adaptive Back Button (Chevron for iOS vs Arrow for Android)
class AdaptiveBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const AdaptiveBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TargetPlatform>(
      valueListenable: AdaptivePlatform.platformNotifier,
      builder: (context, platform, child) {
        final isIOS = platform == TargetPlatform.iOS;

        return IconButton(
          icon: Icon(
            isIOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_rounded,
            size: isIOS ? 18 : 22,
            color: color ?? const Color(0xFF111827),
          ),
          onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
        );
      },
    );
  }
}

/// Device Simulator Frame Wrapper (Auto adapts on Mobile / Responsive Simulator and Desktop)
class DeviceSimulatorWrapper extends StatelessWidget {
  final Widget child;

  const DeviceSimulatorWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TargetPlatform>(
      valueListenable: AdaptivePlatform.platformNotifier,
      builder: (context, platform, _) {
        final isIOS = platform == TargetPlatform.iOS;

        return LayoutBuilder(
          builder: (context, constraints) {
            // When viewed on mobile, Chrome DevTools Device Mode, or small screen:
            // Fill 100% of the screen seamlessly!
            if (constraints.maxWidth <= 500) {
              return Material(
                color: Colors.transparent,
                child: child,
              );
            }

            // When viewed on desktop wide screen:
            // Center the device inside a realistic smartphone simulator frame!
            return Scaffold(
              backgroundColor: const Color(0xFF1E293B),
              body: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Platform Switcher Pill at Top of Desktop View
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isIOS ? '📱 Mode Simulator: Apple iOS' : '🤖 Mode Simulator: Google Android',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: AdaptivePlatform.toggle,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E676),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  isIOS ? 'Ganti ke Android' : 'Ganti ke iOS',
                                  style: const TextStyle(
                                    color: Color(0xFF064E3B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Device Frame
                      Container(
                        width: 410,
                        height: 860,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(isIOS ? 48 : 36),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 36,
                              spreadRadius: 4,
                              offset: const Offset(0, 16),
                            ),
                          ],
                          border: Border.all(
                            color: isIOS ? const Color(0xFF334155) : const Color(0xFF475569),
                            width: 10,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(isIOS ? 38 : 26),
                          child: Stack(
                            children: [
                              Positioned.fill(child: child),

                              // Dynamic Island (iOS) vs Camera Punch Hole (Android)
                              Positioned(
                                top: 8,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: isIOS
                                      ? Container(
                                          width: 110,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        )
                                      : Container(
                                          width: 14,
                                          height: 14,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

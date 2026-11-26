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
    return const SizedBox.shrink();
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
    // On native mobile devices (Android/iOS), the OS already provides the status bar
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }

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

/// Pass-through wrapper (emulator bezel removed for clean full-screen display)
class DeviceSimulatorWrapper extends StatelessWidget {
  final Widget child;

  const DeviceSimulatorWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

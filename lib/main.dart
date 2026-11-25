import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poject_lika/firebase_options.dart';

import 'screens/splash_screen.dart';
import 'services/adaptive_device.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TargetPlatform>(
      valueListenable: AdaptivePlatform.platformNotifier,
      builder: (context, currentPlatform, _) {
        return MaterialApp(
          title: 'LIKA Agrowisata',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            platform: currentPlatform,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF15803D),
              primary: const Color(0xFF15803D),
            ),
            scaffoldBackgroundColor: const Color(0xFFFBFBFB),
            useMaterial3: true,
            fontFamily: currentPlatform == TargetPlatform.iOS
                ? 'SF Pro Text'
                : 'Roboto',
          ),
          builder: (context, child) {
            return DeviceSimulatorWrapper(
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}

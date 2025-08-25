// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart'; // Add this
import 'providers/usage_provider.dart';
import 'screens/splash_screen.dart';
import 'services/reminder_service.dart';
import 'services/overlay_service.dart'; // Add this

// Add this overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const OverlayApp());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register overlay entry point - Add this
  FlutterOverlayWindow.overlayListener.listen((data) {
    print("Overlay data received: $data");
  });

  runApp(const EyesMateApp());
}

class EyesMateApp extends StatelessWidget {
  const EyesMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Global navigator key for overlays
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    // Initialize reminder service with navigator key
    ReminderService.initialize(navKey: navigatorKey);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsageProvider()),
        // اگه Provider دیگه هم خواستی اضافه کن
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, // Important: provide the navigator key
        title: 'EyesMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Jost',
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF011222),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
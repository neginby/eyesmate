// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/usage_provider.dart';
import 'screens/splash_screen.dart';
import 'services/reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
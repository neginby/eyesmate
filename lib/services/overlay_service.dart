import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class SystemOverlayService {
  static bool _isOverlayActive = false;

  // Check and request overlay permission
  static Future<bool> checkAndRequestPermission() async {
    bool? hasPermission = await FlutterOverlayWindow.isPermissionGranted();
    if (hasPermission != true) {
      bool? granted = await FlutterOverlayWindow.requestPermission();
      return granted == true;
    }
    return true;
  }

  // Show system overlay
  static Future<bool> showSystemOverlay({
    required int durationSeconds,
    bool isTest = false,
  }) async {
    if (_isOverlayActive) return false;

    bool hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return false;

    _isOverlayActive = true;

    await FlutterOverlayWindow.showOverlay(
      height: 2000,
      width: WindowSize.matchParent,
      overlayTitle: "EyesMate Break Reminder",
      overlayContent: _buildOverlayContent(durationSeconds, isTest),
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      enableDrag: false,
    );

    await Future.delayed(Duration(seconds: durationSeconds));
    await closeSystemOverlay();

    return true;
  }

  // Close system overlay
  static Future<void> closeSystemOverlay() async {
    if (_isOverlayActive) {
      await FlutterOverlayWindow.closeOverlay();
      _isOverlayActive = false;
    }
  }

  // Build overlay content (JSON string)
  static String _buildOverlayContent(int durationSeconds, bool isTest) {
    String title = isTest ? "Test Break Reminder" : "Take a short break!";
    String message = isTest
        ? "This is a test overlay for $durationSeconds seconds."
        : "Continuous screen time can cause eye strain.\nLook away for a few seconds.";

    return '''
    {
      "title": "$title",
      "message": "$message",
      "duration": $durationSeconds,
      "isTest": $isTest
    }
    ''';
  }

  static bool get isOverlayActive => _isOverlayActive;
}

// Overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  runApp(const OverlayApp());
}

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BreakReminderOverlay(),
    );
  }
}

class BreakReminderOverlay extends StatefulWidget {
  const BreakReminderOverlay({super.key});

  @override
  State<BreakReminderOverlay> createState() => _BreakReminderOverlayState();
}

class _BreakReminderOverlayState extends State<BreakReminderOverlay> {
  String _title = "Take a short break!";
  String _message = "Continuous screen time can cause eye strain.\nLook away for few seconds.";

  @override
  void initState() {
    super.initState();
    _setupFullScreen();
  }

  void _setupFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: const Color(0x000c1c74).withOpacity(0.67),
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      child: Center(
                        child: Image.asset(
                          'assets/images/style.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
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
    );
  }
}

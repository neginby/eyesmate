import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'overlay_service.dart';

class ReminderService {
  static const String _reminderEnabledKey = 'reminder_enabled';
  static const String _restDurationKey = 'rest_duration';
  static const String _intervalKey = 'interval';
  static const String _taskName = 'eyesmate_reminder';

  static Timer? _timer;
  static Timer? _periodicTimer;
  static bool _isOverlayActive = false;

  static GlobalKey<NavigatorState>? navigatorKey;

  // Initialize the service
  static Future<void> initialize({GlobalKey<NavigatorState>? navKey}) async {
    navigatorKey = navKey;
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    await SystemOverlayService.checkAndRequestPermission();
  }

  // Start the reminder system
  static Future<void> startReminders({
    required int restDurationSeconds,
    required int intervalMinutes,
  }) async {
    await stopReminders();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderEnabledKey, true);
    await prefs.setInt(_restDurationKey, restDurationSeconds);
    await prefs.setInt(_intervalKey, intervalMinutes);

    bool hasPermission = await SystemOverlayService.checkAndRequestPermission();
    if (!hasPermission) return;

    // Periodic reminders while app is open
    _periodicTimer = Timer.periodic(
      Duration(minutes: intervalMinutes),
          (timer) async {
        bool systemOverlayShown = await SystemOverlayService.showSystemOverlay(
          durationSeconds: restDurationSeconds,
          isTest: false,
        );
        if (!systemOverlayShown && navigatorKey?.currentContext != null) {
          showInAppReminderOverlay(restDurationSeconds);
        }
      },
    );

    // Background reminders
    await Workmanager().registerPeriodicTask(
      _taskName,
      _taskName,
      frequency: Duration(minutes: intervalMinutes.clamp(15, 999)),
      initialDelay: Duration(minutes: intervalMinutes.clamp(15, 999)),
      inputData: {
        'rest_duration': restDurationSeconds,
        'interval': intervalMinutes,
      },
    );
  }

  // Stop the reminder system
  static Future<void> stopReminders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderEnabledKey, false);

    await Workmanager().cancelByUniqueName(_taskName);
    _timer?.cancel();
    _periodicTimer?.cancel();
    _timer = null;
    _periodicTimer = null;

    await SystemOverlayService.closeSystemOverlay();

    if (_isOverlayActive && navigatorKey?.currentContext != null) {
      Navigator.of(navigatorKey!.currentContext!).pop();
      _isOverlayActive = false;
    }
  }

  // Show test overlay
  static Future<void> showTestOverlay({int durationSeconds = 5}) async {
    bool success = await SystemOverlayService.showSystemOverlay(
      durationSeconds: durationSeconds,
      isTest: true,
    );
    if (!success && navigatorKey?.currentContext != null) {
      showInAppReminderOverlay(durationSeconds);
    }
  }

  // Show system reminder overlay
  static Future<void> showReminderOverlay(int durationSeconds) async {
    bool success = await SystemOverlayService.showSystemOverlay(
      durationSeconds: durationSeconds,
      isTest: false,
    );
    if (!success && navigatorKey?.currentContext != null) {
      showInAppReminderOverlay(durationSeconds);
    }
  }

  // In-app overlay
  static Future<void> showInAppReminderOverlay(int durationSeconds) async {
    if (_isOverlayActive || navigatorKey?.currentContext == null) return;
    _showInAppOverlayDialog(durationSeconds);
  }

  static void _showInAppOverlayDialog(int durationSeconds) {
    if (navigatorKey?.currentContext == null) return;

    _isOverlayActive = true;

    showDialog(
      context: navigatorKey!.currentContext!,
      barrierDismissible: false,
      builder: (context) => const OverlayNotificationReminder(),
    );

    _timer = Timer(Duration(seconds: durationSeconds), () {
      if (_isOverlayActive && navigatorKey?.currentContext != null) {
        Navigator.of(navigatorKey!.currentContext!).pop();
        _isOverlayActive = false;
        _timer = null;
      }
    });
  }

  static Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_reminderEnabledKey) ?? false;
  }

  static Future<Map<String, int>> getSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'rest_duration': prefs.getInt(_restDurationKey) ?? 20,
      'interval': prefs.getInt(_intervalKey) ?? 20,
    };
  }

  static Future<bool> checkOverlayPermission() async {
    return await SystemOverlayService.checkAndRequestPermission();
  }
}

// In-app overlay design
class OverlayNotificationReminder extends StatelessWidget {
  const OverlayNotificationReminder({super.key});

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
                      "Take a short break!",
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
                        "Continuous screen time can cause eye strain.\nLook away for few seconds.",
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
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Rest your eyes...",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
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

// Background task callback
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'eyesmate_reminder') {
      final restDuration = inputData?['rest_duration'] ?? 20;
      await SystemOverlayService.showSystemOverlay(
        durationSeconds: restDuration,
        isTest: false,
      );
    }
    return Future.value(true);
  });
}

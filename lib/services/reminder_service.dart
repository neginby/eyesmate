import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class ReminderService {
  static const String _reminderEnabledKey = 'reminder_enabled';
  static const String _restDurationKey = 'rest_duration';
  static const String _intervalKey = 'interval';
  static const String _taskName = 'eyesmate_reminder';

  static Timer? _timer;
  static Timer? _periodicTimer;
  static bool _isOverlayActive = false;

  // Global navigator key for showing overlays from anywhere
  static GlobalKey<NavigatorState>? navigatorKey;

  // Initialize the service
  static Future<void> initialize({GlobalKey<NavigatorState>? navKey}) async {
    try {
      navigatorKey = navKey;
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
      print('ReminderService initialized successfully');
    } catch (e) {
      print('Error initializing reminder service: $e');
    }
  }

  // Start the reminder system
  static Future<void> startReminders({
    required int restDurationSeconds,
    required int intervalMinutes,
  }) async {
    try {
      await stopReminders(); // Stop any existing reminders

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reminderEnabledKey, true);
      await prefs.setInt(_restDurationKey, restDurationSeconds);
      await prefs.setInt(_intervalKey, intervalMinutes);

      // Start periodic timer for in-app reminders
      _periodicTimer = Timer.periodic(
          Duration(minutes: intervalMinutes),
              (timer) {
            if (navigatorKey?.currentContext != null) {
              showReminderOverlay(restDurationSeconds);
            }
          }
      );

      // Also register background task for when app is closed
      await Workmanager().registerPeriodicTask(
        _taskName,
        _taskName,
        frequency: Duration(minutes: intervalMinutes.clamp(15, 999)), // Minimum 15 minutes for workmanager
        initialDelay: Duration(minutes: intervalMinutes.clamp(15, 999)),
        inputData: {
          'rest_duration': restDurationSeconds,
          'interval': intervalMinutes,
        },
      );

      print('Reminders started: Every $intervalMinutes minutes, rest for $restDurationSeconds seconds');
    } catch (e) {
      print('Error starting reminders: $e');
      rethrow;
    }
  }

  // Stop the reminder system
  static Future<void> stopReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_reminderEnabledKey, false);

      await Workmanager().cancelByUniqueName(_taskName);
      _timer?.cancel();
      _periodicTimer?.cancel();
      _timer = null;
      _periodicTimer = null;

      // Close overlay if active
      if (_isOverlayActive && navigatorKey?.currentContext != null) {
        Navigator.of(navigatorKey!.currentContext!).pop();
        _isOverlayActive = false;
      }

      print('Reminders stopped');
    } catch (e) {
      print('Error stopping reminders: $e');
    }
  }

  // Show overlay for testing
  static Future<void> showTestOverlay({int durationSeconds = 5}) async {
    if (_isOverlayActive || navigatorKey?.currentContext == null) {
      print('Cannot show test overlay - overlay active or no context');
      return;
    }

    try {
      print('Showing test overlay for $durationSeconds seconds');
      _showOverlayDialog(durationSeconds);
    } catch (e) {
      print('Error showing test overlay: $e');
      rethrow;
    }
  }

  // Show the actual reminder overlay
  static Future<void> showReminderOverlay(int durationSeconds) async {
    if (_isOverlayActive || navigatorKey?.currentContext == null) {
      print('Cannot show reminder overlay - overlay active or no context');
      return;
    }

    try {
      print('Showing reminder overlay for $durationSeconds seconds');
      _showOverlayDialog(durationSeconds);
    } catch (e) {
      print('Error showing reminder overlay: $e');
    }
  }

  // Internal method to show the overlay dialog
  static void _showOverlayDialog(int durationSeconds) {
    if (navigatorKey?.currentContext == null) return;

    _isOverlayActive = true;

    showDialog(
      context: navigatorKey!.currentContext!,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Prevent back button dismiss
        child: const ReminderOverlayWidget(),
      ),
    );

    // Auto-close after duration
    _timer = Timer(Duration(seconds: durationSeconds), () {
      if (_isOverlayActive && navigatorKey?.currentContext != null) {
        try {
          Navigator.of(navigatorKey!.currentContext!).pop();
          _isOverlayActive = false;
          _timer = null;
          print('Overlay closed automatically after $durationSeconds seconds');
        } catch (e) {
          print('Error closing overlay: $e');
        }
      }
    });
  }

  // Check if reminders are enabled
  static Future<bool> isReminderEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_reminderEnabledKey) ?? false;
    } catch (e) {
      print('Error checking reminder enabled: $e');
      return false;
    }
  }

  // Get saved settings
  static Future<Map<String, int>> getSavedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'rest_duration': prefs.getInt(_restDurationKey) ?? 20,
        'interval': prefs.getInt(_intervalKey) ?? 20,
      };
    } catch (e) {
      print('Error getting saved settings: $e');
      return {
        'rest_duration': 20,
        'interval': 20,
      };
    }
  }
}

// Reminder Overlay Widget
class ReminderOverlayWidget extends StatelessWidget {
  const ReminderOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0x000c1c74).withOpacity(0.67),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Character/Icon
                SizedBox(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  child: Center(
                    child: Image.asset(
                      'assets/images/style.png',
                      fit: BoxFit.contain,
                      // errorBuilder: (context, error, stackTrace) {
                      //   return const Icon(
                      //     Icons.visibility_off,
                      //     color: Colors.white,
                      //     size: 80,
                      //   );
                      // },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Title
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

                const SizedBox(height: 15),

                // Subtitle
                Text(
                  "Continuous screen time can cause eye strain.\nLook away for 20 seconds.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 40),

                // Rest message
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
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

                const SizedBox(height: 30),

                // Close button (optional - can be removed for mandatory break)
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //     ReminderService._isOverlayActive = false;
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color(0xFF8B83B6),
                //     foregroundColor: Colors.white,
                //     padding: EdgeInsets.symmetric(
                //       horizontal: screenWidth * 0.08,
                //       vertical: 12,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(25),
                //     ),
                //   ),
                //   child: Text(
                //     'Got it',
                //     style: TextStyle(
                //       fontFamily: 'Jost',
                //       fontSize: screenWidth * 0.04,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Background task callback (simplified)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      print('Background task executing: $task');
      // For background tasks, we'll just log - the in-app timer handles the overlays
      if (task == 'eyesmate_reminder') {
        print('Background reminder triggered - app should handle this when active');
      }
      return Future.value(true);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}
import 'dart:ui';
import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import '../models/usage_models.dart';

class UsageService {
  static final UsageService _instance = UsageService._internal();
  factory UsageService() => _instance;
  UsageService._internal();

  /// لیست اپ‌های سیستمی که نمی‌خوایم حساب بشن
  final List<String> _excludedPackages = const [
    'com.android.systemui',
    'com.samsung.android.incallui',
    'android',
    'com.android.launcher',
    'com.sec.android.app.launcher',
    'com.android.settings',
    'com.google.android.gms',
    'com.google.android.gsf',
    'com.android.vending', // Play Store
  ];

  /// چک کردن پرمیشن
  Future<bool> hasUsagePermission() async {
    try {
      final now = DateTime.now();
      final start = now.subtract(const Duration(hours: 1));
      await AppUsage().getAppUsage(start, now);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// درخواست پرمیشن
  Future<void> requestUsagePermission() async {
    throw Exception(
      'Please enable "Usage Access" permission:\n'
          '1. Go to Settings\n'
          '2. Search for "Usage Access" or "App Usage Access"\n'
          '3. Find your app and enable permission',
    );
  }

  /// کل زمان استفاده امروز
  Future<Duration> getTotalScreenTimeToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final usage = await AppUsage().getAppUsage(startOfDay, now);

      Duration totalTime = Duration.zero;
      for (final app in usage) {
        if (!_isSystemApp(app.packageName)) {
          totalTime += app.usage;
          // برای دیباگ
          print("${app.appName} (${app.packageName}) => ${app.usage.inMinutes} min");
        }
      }

      print(">>> Total Screen Time: ${totalTime.inMinutes} min");
      return totalTime;
    } catch (e) {
      print('Error getting total screen time: $e');
      return Duration.zero;
    }
  }

  /// گرفتن ۴ اپ پرمصرف امروز
  Future<List<AppUsageData>> getTop4AppsToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final usage = await AppUsage().getAppUsage(startOfDay, now);

      final filteredUsage = usage.where((app) =>
      app.usage.inMinutes > 0 && !_isSystemApp(app.packageName)).toList();

      filteredUsage.sort((a, b) => b.usage.compareTo(a.usage));

      final top4 = filteredUsage.take(4).toList();
      final totalUsage = filteredUsage.fold<Duration>(
        Duration.zero,
            (total, app) => total + app.usage,
      );

      List<AppUsageData> result = [];
      for (int i = 0; i < top4.length; i++) {
        final app = top4[i];
        final percentage = totalUsage.inMinutes > 0
            ? (app.usage.inMinutes / totalUsage.inMinutes * 100).round()
            : 0;

        print(">>> Top App: ${app.appName} => ${app.usage.inMinutes} min ($percentage%)");

        result.add(AppUsageData(
          appName: await _getAppName(app.packageName),
          packageName: app.packageName,
          percentage: percentage,
          timeSpent: _formatDuration(app.usage),
          color: _getAppColor(app.packageName),
          usage: app.usage,
        ));
      }

      return result;
    } catch (e) {
      print('Error getting top apps: $e');
      return [];
    }
  }

  /// گرفتن اسم اپ
  Future<String> _getAppName(String packageName) async {
    try {
      final app = await DeviceApps.getApp(packageName);
      return app?.appName ?? _getDisplayNameFromPackage(packageName);
    } catch (e) {
      return _getDisplayNameFromPackage(packageName);
    }
  }

  String _getDisplayNameFromPackage(String packageName) {
    final parts = packageName.split('.');
    if (parts.isNotEmpty) {
      final name = parts.last;
      return name[0].toUpperCase() + name.substring(1);
    }
    return packageName;
  }

  /// چک کردن اپ سیستمی
  bool _isSystemApp(String packageName) {
    return _excludedPackages.contains(packageName) ||
        packageName.startsWith('com.android.') ||
        packageName.startsWith('com.google.android.');
  }

  /// رنگ برای اپ‌ها
  Color _getAppColor(String packageName) {
    final appColors = {
      'twitter': const Color(0xFF1DA1F2),
      'facebook': const Color(0xFF4267B2),
      'instagram': const Color(0xFFE4405F),
      'whatsapp': const Color(0xFF25D366),
      'telegram': const Color(0xFF0088CC),
      'youtube': const Color(0xFFFF0000),
      'netflix': const Color(0xFFE50914),
      'spotify': const Color(0xFF1DB954),
      'tiktok': const Color(0xFF000000),
      'snapchat': const Color(0xFFFFFC00),
      'linkedin': const Color(0xFF0077B5),
      'reddit': const Color(0xFFFF4500),
      'pinterest': const Color(0xFFBD081C),
      'discord': const Color(0xFF7289DA),
      'twitch': const Color(0xFF9146FF),
    };

    final packageLower = packageName.toLowerCase();
    for (final entry in appColors.entries) {
      if (packageLower.contains(entry.key)) {
        return entry.value;
      }
    }

    final defaultColors = [
      const Color(0xFF8B83B6),
      const Color(0xFF6B73C6),
      const Color(0xFF5B9BD5),
      const Color(0xFF70AD47),
      const Color(0xFFFFC000),
      const Color(0xFFFF6B35),
    ];

    return defaultColors[packageName.hashCode % defaultColors.length];
  }

  /// فرمت مدت زمان
  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final h = duration.inHours;
      final m = duration.inMinutes % 60;
      return m > 0 ? "${h}h ${m}m" : "${h}h";
    } else {
      return "${duration.inMinutes}m";
    }
  }

  /// درصد مصرف نسبت به benchmark (۶ ساعت)
  double calculateUsagePercentage(Duration totalScreenTime) {
    const benchmarkMinutes = 6 * 60;
    return (totalScreenTime.inMinutes / benchmarkMinutes * 100).clamp(0, 200);
  }

  /// پیام انگیزشی
  String generateMotivationalMessage(double usagePercentage) {
    if (usagePercentage < 30) {
      return "Excellent! Your screen time was ${usagePercentage.round()}% of the average teen usage today. You're doing great!";
    } else if (usagePercentage < 60) {
      return "Good job! Your screen time was ${usagePercentage.round()}% of the average teen usage today. Keep it balanced!";
    } else if (usagePercentage < 100) {
      return "Your screen time was ${usagePercentage.round()}% of the average teen usage today. Consider taking more breaks!";
    } else {
      return "Your screen time was ${usagePercentage.round()}% of the average teen usage today. Time for a digital detox!";
    }
  }

  /// تاریخ امروز
  String getCurrentDateFormatted() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final day = now.day;
    final month = months[now.month - 1];
    return 'Today, $month ${_getDayWithSuffix(day)}';
  }

  String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1: return '${day}st';
      case 2: return '${day}nd';
      case 3: return '${day}rd';
      default: return '${day}th';
    }
  }

// calender part

  /// گرفتن زمان استفاده برای تاریخ خاص
  Future<Duration> getScreenTimeForDate(DateTime startDate, DateTime endDate) async {
    try {
      final usage = await AppUsage().getAppUsage(startDate, endDate);

      Duration totalTime = Duration.zero;
      for (final app in usage) {
        if (!_isSystemApp(app.packageName)) {
          totalTime += app.usage;
        }
      }

      print(">>> Screen Time for ${startDate.toString().split(' ')[0]}: ${totalTime.inMinutes} min");
      return totalTime;
    } catch (e) {
      print('Error getting screen time for date: $e');
      return Duration.zero;
    }
  }

  /// گرفتن داده‌های ۳۰ روز گذشته
  Future<Map<DateTime, Duration>> getScreenTimeForPast30Days() async {
    try {
      final Map<DateTime, Duration> data = {};
      final now = DateTime.now();

      for (int i = 0; i <= 30; i++) {
        final date = now.subtract(Duration(days: i));
        final dayStart = DateTime(date.year, date.month, date.day);
        final dayEnd = DateTime(date.year, date.month, date.day, 23, 59, 59);

        try {
          final screenTime = await getScreenTimeForDate(dayStart, dayEnd);
          if (screenTime.inMinutes > 0) {
            data[DateTime(date.year, date.month, date.day)] = screenTime;
          }
        } catch (e) {
          print('Error loading data for ${date.toString()}: $e');
        }
      }

      return data;
    } catch (e) {
      print('Error loading 30-day screen time data: $e');
      return {};
    }
  }
}

import 'package:flutter/material.dart';

/// Model for app usage data
class AppUsageData {
  final String appName;
  final String packageName;
  final int percentage;
  final String timeSpent;
  final Color color;
  final Duration usage; // Raw duration for calculations

  AppUsageData({
    required this.appName,
    required this.packageName,
    required this.percentage,
    required this.timeSpent,
    required this.color,
    required this.usage,
  });

  /// Create from app usage stats
  factory AppUsageData.fromUsageStats({
    required String appName,
    required String packageName,
    required Duration usage,
    required int percentage,
    required Color color,
  }) {
    return AppUsageData(
      appName: appName,
      packageName: packageName,
      percentage: percentage,
      timeSpent: _formatDuration(usage),
      color: color,
      usage: usage,
    );
  }

  /// Format duration to readable string
  static String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  @override
  String toString() {
    return 'AppUsageData(appName: $appName, percentage: $percentage, timeSpent: $timeSpent)';
  }
}

/// Model for daily usage summary
class DailyUsageSummary {
  final DateTime date;
  final Duration totalScreenTime;
  final int totalHours;
  final int totalMinutes;
  final List<AppUsageData> topApps;
  final double usagePercentage;
  final String motivationalMessage;
  final String formattedDate;

  DailyUsageSummary({
    required this.date,
    required this.totalScreenTime,
    required this.topApps,
    required this.usagePercentage,
    required this.motivationalMessage,
    required this.formattedDate,
  }) : totalHours = totalScreenTime.inHours,
        totalMinutes = totalScreenTime.inMinutes % 60;

  /// Check if usage is lower than benchmark (6 hours)
  bool get isLowerThanBenchmark => usagePercentage < 100;

  /// Get formatted total screen time
  String get formattedTotalScreenTime {
    if (totalHours > 0) {
      if (totalMinutes > 0) {
        return '${totalHours}h ${totalMinutes}m';
      }
      return '${totalHours}h';
    } else {
      return '${totalMinutes}m';
    }
  }

  @override
  String toString() {
    return 'DailyUsageSummary(date: $formattedDate, totalScreenTime: $formattedTotalScreenTime, topApps: ${topApps.length})';
  }
}

/// Model for usage loading states
enum UsageLoadingState {
  loading,
  loaded,
  error,
  permissionDenied,
}

/// Model for usage errors
class UsageError {
  final String message;
  final UsageErrorType type;

  const UsageError(this.message, this.type);

  @override
  String toString() => message;
}

enum UsageErrorType {
  permissionDenied,
  apiError,
  noData,
  unknown,
}
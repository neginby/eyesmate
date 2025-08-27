import 'package:flutter/material.dart';
import '../models/usage_models.dart';
import '../services/usage_service.dart';



class UsageProvider extends ChangeNotifier {
  final UsageService _usageService = UsageService();

  // State variables
  UsageLoadingState _loadingState = UsageLoadingState.loading;
  DailyUsageSummary? _dailySummary;
  UsageError? _error;

  // Getters
  UsageLoadingState get loadingState => _loadingState;
  DailyUsageSummary? get dailySummary => _dailySummary;
  UsageError? get error => _error;

  bool get isLoading => _loadingState == UsageLoadingState.loading;
  bool get hasError => _loadingState == UsageLoadingState.error;
  bool get hasPermissionError => _loadingState == UsageLoadingState.permissionDenied;
  bool get hasData => _loadingState == UsageLoadingState.loaded && _dailySummary != null;

  /// Initialize and load usage data
  Future<void> initialize() async {
    _setLoadingState(UsageLoadingState.loading);
    await loadUsageData();
  }

  /// Load usage data from service
  Future<void> loadUsageData() async {
    try {
      _setLoadingState(UsageLoadingState.loading);
      _clearError();

      // Check permission first
      final hasPermission = await _usageService.hasUsagePermission();
      if (!hasPermission) {
        _setError(
          const UsageError(
            'Usage access permission is required to display screen time data.',
            UsageErrorType.permissionDenied,
          ),
        );
        _setLoadingState(UsageLoadingState.permissionDenied);
        return;
      }

      // Fetch all required data
      final futures = await Future.wait([
        _usageService.getTotalScreenTimeToday(),
        _usageService.getTop4AppsToday(),
      ]);

      final totalScreenTime = futures[0] as Duration;
      final topApps = futures[1] as List<AppUsageData>;

      // Calculate additional data
      final usagePercentage = _usageService.calculateUsagePercentage(totalScreenTime);
      final motivationalMessage = _usageService.generateMotivationalMessage(usagePercentage);
      final formattedDate = _usageService.getCurrentDateFormatted();

      // Create summary object
      _dailySummary = DailyUsageSummary(
        date: DateTime.now(),
        totalScreenTime: totalScreenTime,
        topApps: topApps,
        usagePercentage: usagePercentage,
        motivationalMessage: motivationalMessage,
        formattedDate: formattedDate,
      );

      _setLoadingState(UsageLoadingState.loaded);

    } catch (e) {
      print('Error loading usage data: $e');
      _setError(
        UsageError(
          'Failed to load usage data: ${e.toString()}',
          UsageErrorType.apiError,
        ),
      );
      _setLoadingState(UsageLoadingState.error);
    }
  }

  /// Request usage permission
  Future<void> requestUsagePermission() async {
    try {
      await _usageService.requestUsagePermission();
      // After user potentially grants permission, try loading data again
      await Future.delayed(const Duration(seconds: 1));
      await loadUsageData();
    } catch (e) {
      _setError(
        UsageError(
          e.toString(),
          UsageErrorType.permissionDenied,
        ),
      );
    }
  }

  /// Refresh usage data
  Future<void> refresh() async {
    await loadUsageData();
  }

  /// Set loading state and notify listeners
  void _setLoadingState(UsageLoadingState state) {
    if (_loadingState != state) {
      _loadingState = state;
      notifyListeners();
    }
  }

  /// Set error and notify listeners
  void _setError(UsageError error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void _clearError() {
    _error = null;
  }

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
  }
}
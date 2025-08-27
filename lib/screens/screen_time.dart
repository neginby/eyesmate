import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/screen_time_widgets.dart';
import '../providers/usage_provider.dart';
import '../models/usage_models.dart';
import 'calendar_page.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  void initState() {
    super.initState();
    // Initialize usage data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UsageProvider>().initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF011222),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                  ),
                ),

                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Header with back button and logo
                        _buildHeader(screenWidth),
                        SizedBox(height: screenHeight * 0.03),

                        // Consumer for reactive UI updates
                        Consumer<UsageProvider>(
                          builder: (context, usageProvider, child) {
                            return _buildContent(
                              context,
                              usageProvider,
                              screenWidth,
                              screenHeight,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(double screenWidth) {
    return Row(
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SizedBox(
            width: 40,
            height: 40,
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        // Spacer to center the logo
        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  height: 35,
                  child: Image.asset('assets/images/icon1.png', fit: BoxFit.contain),
                ),
                SizedBox(width: screenWidth * 0.03),
                Text(
                  'EyesMate',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Calendar icon placeholder
        // In the _buildHeader method, replace the calendar icon container with this:
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalendarScreenTimePage(),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8B83B6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// Build main content based on provider state
  Widget _buildContent(
      BuildContext context,
      UsageProvider usageProvider,
      double screenWidth,
      double screenHeight,
      ) {
    // Show loading state
    if (usageProvider.isLoading) {
      return _buildLoadingState(screenWidth, screenHeight);
    }

    // Show permission error
    if (usageProvider.hasPermissionError) {
      return _buildPermissionError(context, usageProvider, screenWidth, screenHeight);
    }

    // Show general error
    if (usageProvider.hasError) {
      return _buildErrorState(context, usageProvider, screenWidth, screenHeight);
    }

    // Show data
    if (usageProvider.hasData) {
      return _buildDataContent(usageProvider.dailySummary!, screenWidth, screenHeight);
    }

    // Fallback
    return _buildErrorState(context, usageProvider, screenWidth, screenHeight);
  }

  /// Build loading state UI
  Widget _buildLoadingState(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary title (static)
        Text(
          'Summary',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          'Loading...',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        SizedBox(height: screenHeight * 0.1),

        // Loading indicator
        Center(
          child: Column(
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B83B6)),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Loading your screen time data...',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.04,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build permission error UI
  Widget _buildPermissionError(
      BuildContext context,
      UsageProvider usageProvider,
      double screenWidth,
      double screenHeight,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenHeight * 0.05),

        // Permission error card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0C182C),
                Color(0xFF313050),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.security,
                color: const Color(0xFFFF6B35),
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Permission Required',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'To show your screen time data, please enable "Usage Access" permission in Settings.',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.04,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),

              // Instructions
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to enable:',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      '1. Tap "Open Settings" below\n'
                          '2. Find "EyesMate" in the list\n'
                          '3. Enable the permission\n'
                          '4. Return to this app',
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.035,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Open Settings Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await usageProvider.requestUsagePermission();
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: const Color(0xFFFF6B35),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B83B6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Open Settings',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build general error state UI
  Widget _buildErrorState(
      BuildContext context,
      UsageProvider usageProvider,
      double screenWidth,
      double screenHeight,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenHeight * 0.05),

        // Error card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0C182C),
                Color(0xFF313050),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                color: const Color(0xFFFF6B35),
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Unable to Load Data',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                usageProvider.error?.message ?? 'An unexpected error occurred.',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.04,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),

              // Retry button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => usageProvider.refresh(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B83B6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build data content UI
  Widget _buildDataContent(
      DailyUsageSummary summary,
      double screenWidth,
      double screenHeight,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary title with REAL date
        Text(
          'Summary',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          summary.formattedDate, // REAL current date
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.7),
          ),
        ),

        SizedBox(height: screenHeight * 0.03),

        // Total screen time card with REAL data
        TotalScreenTimeCard(
          totalHours: summary.totalHours,
          totalMinutes: summary.totalMinutes,
          dailyGoalHours: 3, // You can make this configurable later
        ),

        SizedBox(height: screenHeight * 0.03),

        // Usage and Typical Range labels
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'Usage',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.rectangle,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              'Typical Range',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.02),

        // App usage chart with REAL top 4 apps
        AppUsageChart(appData: summary.topApps),

        SizedBox(height: screenHeight * 0.03),

        // Screen time comparison card with REAL motivational message
        ScreenTimeComparisonCard(
          comparisonText: summary.motivationalMessage,
          userTime: summary.formattedTotalScreenTime,
          isLowerThanPeers: summary.isLowerThanBenchmark,
          usagePercentage: summary.usagePercentage,
        ),

        SizedBox(height: screenHeight * 0.03),

        // Refresh button (optional - for testing)
         if (const bool.fromEnvironment('dart.vm.product') == false) // Only in debug mode
          Center(
            child: TextButton.icon(
              onPressed: () => context.read<UsageProvider>().refresh(),
              icon: const Icon(Icons.refresh, color: Color(0xFF8B83B6)),
              label: Text(
                'Refresh Data',
                style: TextStyle(
                  fontFamily: 'Jost',
                  color: const Color(0xFF8B83B6),
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
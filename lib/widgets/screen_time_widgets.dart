// lib/widgets/screen_time_widgets.dart
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import '../models/usage_models.dart';


class TotalScreenTimeCard extends StatelessWidget {
  final int totalHours;
  final int totalMinutes;
  final int dailyGoalHours;

  const TotalScreenTimeCard({
    super.key,
    required this.totalHours,
    required this.totalMinutes,
    required this.dailyGoalHours,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate progress percentage
    final totalMinutesToday = (totalHours * 60) + totalMinutes;
    final goalMinutes = dailyGoalHours * 60;
    final progressPercentage = goalMinutes > 0 ? (totalMinutesToday / goalMinutes).clamp(0.0, 1.0) : 0.0;

    return Container(
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
      child: Row(
        children: [
          // Circular progress indicator with real progress
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                // Background circle
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF8B83B6).withOpacity(0.3),
                      width: 4,
                    ),
                  ),
                ),
                // Progress circle
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progressPercentage,
                    strokeWidth: 4,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressPercentage > 0.8
                          ? const Color(0xFFFF6B35) // Red if over 80%
                          : const Color(0xFF8B83B6), // Default purple
                    ),
                  ),
                ),
                // Center icon
                const Center(
                  child: Icon(
                    Icons.access_time,
                    color: Color(0xFF8B83B6),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.04),

          // Time information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$totalHours',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'hr ',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      TextSpan(
                        text: '$totalMinutes',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'min',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: progressPercentage > 0.8
                            ? const Color(0xFFFF6B35)
                            : const Color(0xFF98C897),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        progressPercentage > 1.0
                            ? 'Exceeded daily goal by ${((progressPercentage - 1) * dailyGoalHours).toStringAsFixed(1)} hours'
                            : 'Daily goal $dailyGoalHours hours',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppUsageChart extends StatelessWidget {
  final List<AppUsageData> appData;

  const AppUsageChart({
    super.key,
    required this.appData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (appData.isEmpty) {
      return _buildNoDataWidget(screenWidth, screenHeight);
    }

    return Column(
      children: appData.map((app) =>
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: _buildAppUsageBar(context, app, screenWidth, screenHeight),
          ),
      ).toList(),
    );
  }

  /// Build widget for when no app data is available
  Widget _buildNoDataWidget(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.apps,
            color: Colors.white.withOpacity(0.5),
            size: screenWidth * 0.1,
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'No app usage data available',
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppUsageBar(BuildContext context, AppUsageData app, double screenWidth, double screenHeight) {
    return Row(
      children: [
        // Percentage and progress bar
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Percentage text
              Text(
                '${app.percentage}%',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              // Progress bar container
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    // Background pattern (typical range)
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomPaint(
                        painter: DiagonalPatternPainter(),
                        size: const Size(double.infinity, 20),
                      ),
                    ),
                    // Actual usage bar
                    FractionallySizedBox(
                      widthFactor: app.percentage / 100, // Use actual percentage
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: app.color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: screenWidth * 0.02),

        // App icon - Real app icon placeholder
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: app.color,
            borderRadius: BorderRadius.circular(4),
          ),

          child: FutureBuilder<Application?>(
            future: DeviceApps.getApp(app.packageName, true),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data is ApplicationWithIcon) {
                return Image.memory((snapshot.data as ApplicationWithIcon).icon);
              }
              return getAppIconWidget(app.packageName.toLowerCase());
            },
          ),
        ),

        SizedBox(width: screenWidth * 0.02),

        // Time spent - Using real data
        SizedBox(
          width: screenWidth * 0.15,
          child: Text(
            app.timeSpent, // Real usage time
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper method to get appropriate icons for each app based on package name
  Widget getAppIconWidget(String packageLower) {
    if (packageLower.contains('twitter') || packageLower.contains('x')) {
      return Image.asset('assets/images/twitter.png', width: 24, height: 24);
    } else if (packageLower.contains('spotify') || packageLower.contains('music')) {
      return Image.asset('assets/images/spotify.png', width: 24, height: 24);
    } else if (packageLower.contains('youtube')) {
      return Image.asset('assets/images/youtube.png', width: 24, height: 24);
    }
    else if (packageLower.contains('telegram')) {
      return Image.asset('assets/images/telegram.png', width: 24, height: 24);
    }else if (packageLower.contains('instagram')) {
      return Image.asset('assets/images/instagram.png', width: 24, height: 24);
    }else if (packageLower.contains('youtube')) {
      return Image.asset('assets/images/youtube.png', width: 24, height: 24);
    }
    // ... بقیه موارد
    else {
      return Image.asset('assets/image/default.png', width: 24, height: 24);
    }
  }
}

class DiagonalPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width + size.height; i += 6) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ScreenTimeComparisonCard extends StatelessWidget {
  final String comparisonText;
  final String userTime;
  final bool isLowerThanPeers;
  final double usagePercentage;

  const ScreenTimeComparisonCard({
    super.key,
    required this.comparisonText,
    required this.userTime,
    required this.isLowerThanPeers,
    this.usagePercentage = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fire icon and title
          Row(
            children: [
              Icon(
                usagePercentage < 60
                    ? Icons.local_fire_department
                    : usagePercentage < 100
                    ? Icons.warning_amber
                    : Icons.error,
                color: usagePercentage < 60
                    ? const Color(0xFF98C897) // Green for good
                    : usagePercentage < 100
                    ? const Color(0xFFFFC000) // Yellow for moderate
                    : const Color(0xFFFF6B35), // Red for high
                size: 24,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                'Screen time',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: usagePercentage < 60
                      ? const Color(0xFF98C897)
                      : usagePercentage < 100
                      ? const Color(0xFFFFC000)
                      : const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Comparison text with real data
          Text(
            comparisonText, // Real motivational message
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.4,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          // Horizontal comparison graph with real percentage
          _buildComparisonGraph(screenWidth, screenHeight),

          SizedBox(height: screenHeight * 0.01),

          // User label with real screen time
          Center(
            child: Column(
              children: [
                Text(
                  'You',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  userTime, // Real user time
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonGraph(double screenWidth, double screenHeight) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final barCount = (availableWidth / 3).floor();

          // Calculate position based on real usage percentage
          final positionRatio = (usagePercentage / 200).clamp(0.0, 1.0); // 200% is max
          final markerPosition = (availableWidth * positionRatio).clamp(0.0, availableWidth - 2);

          return Stack(
            children: [
              // Background bars representing time segments
              Row(
                children: List.generate(barCount, (index) {
                  final barPosition = index / barCount;
                  Color barColor;

                  if (barPosition < 0.3) {
                    barColor = const Color(0xFF98C897).withOpacity(0.6); // Green zone
                  } else if (barPosition < 0.5) {
                    barColor = const Color(0xFFFFC000).withOpacity(0.6); // Yellow zone
                  } else {
                    barColor = const Color(0xFFFF6B35).withOpacity(0.6); // Red zone
                  }

                  return Container(
                    width: (availableWidth - (barCount - 1)) / barCount,
                    height: 8,
                    margin: EdgeInsets.only(right: index < barCount - 1 ? 1 : 0),
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),

              // User position marker at real position
              Positioned(
                left: markerPosition,
                child: Container(
                  width: 2,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
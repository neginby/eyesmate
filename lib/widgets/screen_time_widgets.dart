// /lib/widgets/screen_time_widgets.dart
import 'package:flutter/material.dart';

class AppUsageData {
  final String appName;
  final int percentage;
  final String timeSpent;
  final Color color;

  AppUsageData({
    required this.appName,
    required this.percentage,
    required this.timeSpent,
    required this.color,
  });
}

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
          // Circular progress indicator (placeholder)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF8B83B6),
                width: 4,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.access_time,
                color: Color(0xFF8B83B6),
                size: 24,
              ),
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
                        text: '${totalHours}',
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
                        text: '${totalMinutes}',
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
                      decoration: const BoxDecoration(
                        color: Color(0xFF98C897),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Expanded(
                      child: Text(
                        'Daily goal $dailyGoalHours hours',
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

    return Column(
      children: appData.map((app) =>
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: _buildAppUsageBar(context, app, screenWidth, screenHeight),
          ),
      ).toList(),
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
                      widthFactor: app.percentage / 15, // Adjust based on max percentage for scaling
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

        // App icon placeholder - FIXED: No asset loading, just colored placeholder
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: app.color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            _getAppIcon(app.appName),
            color: Colors.white,
            size: 16,
          ),
          // TODO: Replace with actual app icons later
          // child: Image.asset('assets/images/${app.appName.toLowerCase()}_icon.png'),
        ),

        SizedBox(width: screenWidth * 0.02),

        // Time spent - FIXED: Using flexible to prevent overflow
        SizedBox(
          width: screenWidth * 0.15,
          child: Text(
            app.timeSpent,
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

  // Helper method to get appropriate icons for each app
  IconData _getAppIcon(String appName) {
    switch (appName.toLowerCase()) {
      case 'twitter':
        return Icons.alternate_email;
      case 'spotify':
        return Icons.music_note;
      case 'youtube':
        return Icons.play_circle_filled;
      case 'netflix':
        return Icons.movie;
      default:
        return Icons.apps;
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

  const ScreenTimeComparisonCard({
    super.key,
    required this.comparisonText,
    required this.userTime,
    required this.isLowerThanPeers,
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
              const Icon(
                Icons.local_fire_department,
                color: Color(0xFFFF6B35),
                size: 24,
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                'Screen time',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF6B35),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Comparison text
          Text(
            comparisonText,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.4,
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          // Horizontal comparison graph - FIXED: Proper spacing and overflow handling
          _buildComparisonGraph(screenWidth, screenHeight),

          SizedBox(height: screenHeight * 0.01),

          // "You" label
          Center(
            child: Text(
              'You',
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
          final barCount = (availableWidth / 3).floor(); // Calculate bars that fit

          return Stack(
            children: [
              // Background bars (representing time segments) - FIXED: Dynamic bar count
              Row(
                children: List.generate(barCount, (index) =>
                    Container(
                      width: (availableWidth - (barCount - 1)) / barCount,
                      height: 8,
                      margin: EdgeInsets.only(right: index < barCount - 1 ? 1 : 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF98C897).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ),
              ),

              // User position marker - FIXED: Proper positioning within bounds
              Positioned(
                left: (availableWidth * 0.3).clamp(0.0, availableWidth - 2),
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
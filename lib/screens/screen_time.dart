// /lib/screens/page2.dart
import 'package:flutter/material.dart';
import '../widgets/screen_time_widgets.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  // Mock data - replace with real data later
  final List<AppUsageData> mockAppData = [
    AppUsageData(
      appName: "Twitter",
      percentage: 10,
      timeSpent: "22min",
      color: const Color(0xFF1DA1F2),
    ),
    AppUsageData(
      appName: "Spotify",
      percentage: 5,
      timeSpent: "12min",
      color: const Color(0xFF1DB954),
    ),
    AppUsageData(
      appName: "YouTube",
      percentage: 7,
      timeSpent: "18min",
      color: const Color(0xFFFF0000),
    ),
    AppUsageData(
      appName: "Netflix",
      percentage: 1,
      timeSpent: "5min",
      color: const Color(0xFFE50914),
    ),
  ];

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
                // Background image - ADD YOUR BACKGROUND IMAGE HERE
                // Positioned.fill(
                //   child: Image.asset(
                //     'assets/images/background.png',
                //     fit: BoxFit.cover,
                //   ),
                // ),

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
                        Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
                                      // ADD YOUR LOGO IMAGE HERE
                                        child: Image.asset('assets/images/icon1.png', fit: BoxFit.contain),
                                      // child: Container(
                                      //   decoration: BoxDecoration(
                                      //     color: const Color(0xFF8B83B6),
                                      //     borderRadius: BorderRadius.circular(8),
                                      //   ),
                                      // ),
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
                            Container(
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
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Summary title and date
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
                          'Today, October 14th',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Total screen time card
                        TotalScreenTimeCard(
                          totalHours: 2,
                          totalMinutes: 46,
                          dailyGoalHours: 3,
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

                        // App usage chart
                        AppUsageChart(appData: mockAppData),

                        SizedBox(height: screenHeight * 0.03),

                        // Screen time comparison card
                        const ScreenTimeComparisonCard(
                          comparisonText: "Your screen time was 20% lower than your peers today. Keep going!",
                          userTime: "2h 12m",
                          isLowerThanPeers: true,
                        ),

                        SizedBox(height: screenHeight * 0.03),
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
}
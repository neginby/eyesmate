import 'package:flutter/material.dart';
import 'dart:math' as math;

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool isScreenDistanceAlertEnabled = true;
  String currentDistance = "33";
  bool isCameraActive = false;

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
                      children: [
                        // Header with back button and logo
                        Row(
                          children: [
                            // Back button
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
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
                            // Invisible container to balance the layout
                            Container(width: 40),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.08),

                        // Main circular camera widget
                        _buildCameraWidget(screenWidth, screenHeight),

                        SizedBox(height: screenHeight * 0.08),

                        // Information text section
                        _buildInformationSection(screenWidth, screenHeight),

                        SizedBox(height: screenHeight * 0.08),

                        // Screen Distance Alert toggle
                        _buildDistanceAlertToggle(screenWidth, screenHeight),

                        SizedBox(height: screenHeight * 0.06),
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

  Widget _buildCameraWidget(double screenWidth, double screenHeight) {
    final circleRadius = screenWidth * 0.35;

    return SizedBox(
      width: circleRadius * 2,
      height: circleRadius * 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom painted circular progress with segments
          CustomPaint(
            size: Size(circleRadius * 2, circleRadius * 2),
            painter: CircularProgressPainter(
              radius: circleRadius,
              strokeWidth: 8,
              color: const Color(0x808B83B6),
            ),
          ),

          // Inner camera circle
          GestureDetector(
            onTap: () {
              setState(() {
                isCameraActive = !isCameraActive;
              });
              // TODO: Add camera functionality here later
              print("Camera tapped - implement camera logic");
            },
            child: Container(
              width: circleRadius * 1.8,
              height: circleRadius * 1.8,
              decoration: BoxDecoration(
                color: const Color(0xFF8B83B6),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: isCameraActive
                    ? Container(
                  // Placeholder for camera feed
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'Camera Feed\nWill Appear Here',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
                    : SizedBox(
                  width: 150,
                  height: 150,
                  // ADD YOUR CAMERA ICON IMAGE HERE
                  child: Image.asset(
                    'assets/images/camera_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Distance indicator at bottom of circle
          Positioned(
            bottom: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '$currentDistance cm',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF011222),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationSection(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '     Let\'s Check Your Distance!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        Text(
          'Tap the camera icon to start measuring your distance.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.4,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
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
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The average recommended distance from your screen is about 33 cm.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.037,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                'We\'ll help you stay in the safe zone and protect your eyes.',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.037,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDistanceAlertToggle(double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Screen Distance Alert :',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Switch(
          value: isScreenDistanceAlertEnabled,
          onChanged: (value) {
            setState(() {
              isScreenDistanceAlertEnabled = value;
            });
          },
          activeColor: const Color(0xFF8B83B6),
          inactiveThumbColor: const Color(0xFF5B5B82),
          inactiveTrackColor: const Color(0xFF313050),
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Color color;

  CircularProgressPainter({
    required this.radius,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);
    final circleRadius = radius - strokeWidth / 2;

    // Draw segmented progress ring
    _drawSegments(canvas, center, circleRadius);
  }

  void _drawSegments(Canvas canvas, Offset center, double circleRadius) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const segmentCount = 40; // Number of segments around the circle
    const gapAngle = 0.08; // Gap between segments
    final segmentAngle = (2 * math.pi / segmentCount) - gapAngle;

    for (int i = 0; i < segmentCount; i++) {
      final startAngle = (i * (2 * math.pi / segmentCount)) - math.pi / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: circleRadius),
        startAngle,
        segmentAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
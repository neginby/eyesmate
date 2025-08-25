import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../services/reminder_service.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int selectedMinutes = 20;
  int selectedSeconds = 20;
  bool isReminderEnabled = true;
  bool _isLoading = false; // For loading states

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSavedSettings() async {
    final settings = await ReminderService.getSavedSettings();
    final isEnabled = await ReminderService.isReminderEnabled();

    setState(() {
      selectedSeconds = settings['rest_duration'] ?? 20;
      selectedMinutes = settings['interval'] ?? 20;
      isReminderEnabled = isEnabled;
    });
  }

  // Handle reminder toggle
  Future<void> _handleReminderToggle(bool value) async {
    setState(() {
      _isLoading = true;
      isReminderEnabled = value;
    });

    try {
      if (value) {
        // Check overlay permission first
        bool hasPermission = await ReminderService.checkOverlayPermission();

        if (!hasPermission) {
          // Show permission dialog
          // if (mounted) {
          //   _showPermissionDialog();
          // }
          setState(() {
            isReminderEnabled = false;
          });
          return;
        }

        // Start reminders
        await ReminderService.startReminders(
          restDurationSeconds: selectedSeconds,
          intervalMinutes: selectedMinutes,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'System-wide reminders started! You\'ll get notifications every $selectedMinutes minutes for $selectedSeconds seconds, even when using other apps.',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color(0xFF98C897),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } else {
        // Stop reminders
        await ReminderService.stopReminders();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Reminders stopped.',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Color(0xFF8B83B6),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // Handle errors
      setState(() {
        isReminderEnabled = !value; // Revert the toggle
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Test button handler
  Future<void> _testOverlay() async {
    try {
      // Check permission first
      bool hasPermission = await ReminderService.checkOverlayPermission();

      // if (!hasPermission) {
      //   _showPermissionDialog();
      //   return;
      // }

      await ReminderService.showTestOverlay(durationSeconds: 5);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Test system overlay shown for 5 seconds! This works even when app is in background. Try pressing home button.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF98C897),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  //
  // // Show permission dialog
  // void _showPermissionDialog() {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // User must make a choice
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: const Color(0xFF313050),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         title: Row(
  //           children: [
  //             Icon(
  //               Icons.security,
  //               color: const Color(0xFF98C897),
  //               size: 28,
  //             ),
  //             const SizedBox(width: 10),
  //             const Text(
  //               'Permission Required',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'To show break reminders even when you\'re using other apps, EyesMate needs permission to "Display over other apps".',
  //               style: TextStyle(
  //                 color: Colors.white70,
  //                 height: 1.4,
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF98C897).withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(8),
  //                 border: Border.all(
  //                   color: const Color(0xFF98C897).withOpacity(0.3),
  //                 ),
  //               ),
  //               child: const Row(
  //                 children: [
  //                   Icon(
  //                     Icons.info_outline,
  //                     color: Color(0xFF98C897),
  //                     size: 20,
  //                   ),
  //                   SizedBox(width: 8),
  //                   Expanded(
  //                     child: Text(
  //                       'This allows reminders to work while using Instagram, WhatsApp, games, etc.',
  //                       style: TextStyle(
  //                         color: Color(0xFF98C897),
  //                         fontSize: 13,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               // Reset the toggle since permission wasn't granted
  //               setState(() {
  //                 isReminderEnabled = false;
  //               });
  //             },
  //             child: const Text(
  //               'Cancel',
  //               style: TextStyle(color: Colors.grey),
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               Navigator.of(context).pop();
  //
  //               // Show loading while requesting permission
  //               if (mounted) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text(
  //                       'Opening permission settings...',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     backgroundColor: Color(0xFF8B83B6),
  //                     duration: Duration(seconds: 2),
  //                   ),
  //                 );
  //               }
  //
  //               // Try to request permission again
  //               bool granted = await ReminderService.checkOverlayPermission();
  //
  //               if (granted && mounted) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text(
  //                       'Permission granted! You can now enable reminders.',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     backgroundColor: Color(0xFF98C897),
  //                     duration: Duration(seconds: 3),
  //                   ),
  //                 );
  //               } else if (mounted) {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     content: Text(
  //                       'Permission not granted. Reminders will only work inside the app.',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     backgroundColor: Colors.orange,
  //                     duration: Duration(seconds: 3),
  //                   ),
  //                 );
  //                 // Reset toggle
  //                 setState(() {
  //                   isReminderEnabled = false;
  //                 });
  //               }
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: const Color(0xFF98C897),
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //             child: const Text('Grant Permission'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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
                // Background
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Main content
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        // Logo and name
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 35,
                                child: Image.asset(
                                  'assets/images/icon1.png',
                                  fit: BoxFit.contain,
                                ),
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

                        SizedBox(height: screenHeight * 0.06),

                        // Circular timer
                        SizedBox(
                          height: screenHeight * 0.4,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer circle (minutes)
                              CircularTimer(
                                radius: screenWidth * 0.43,
                                strokeWidth: 20,
                                value: selectedMinutes,
                                maxValue: 60,
                                color: const Color(0xFF98C897),
                                onChanged: (value) {
                                  setState(() {
                                    selectedMinutes = value;
                                  });
                                  // Update reminders if enabled
                                  if (isReminderEnabled && !_isLoading) {
                                    _handleReminderToggle(true);
                                  }
                                },
                                showTicks: true,
                                handleAsset: 'assets/images/eye_break_icon.png',
                              ),
                              // Inner circle (seconds)
                              CircularTimer(
                                radius: screenWidth * 0.29,
                                strokeWidth: 15,
                                value: selectedSeconds,
                                maxValue: 60,
                                color: const Color(0xFF8B83B6),
                                onChanged: (value) {
                                  setState(() {
                                    selectedSeconds = value;
                                  });
                                  // Update reminders if enabled
                                  if (isReminderEnabled && !_isLoading) {
                                    _handleReminderToggle(true);
                                  }
                                },
                                showTicks: false,
                                handleAsset: 'assets/images/eye_break_icon.png',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // Show values
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildValueContainer(
                              'Rest for :',
                              '$selectedSeconds sec',
                              screenWidth,
                              screenHeight,
                            ),
                            _buildValueContainer(
                              'Every :',
                              '$selectedMinutes minute',
                              screenWidth,
                              screenHeight,
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.05),

                        // Reminder switch
                        _buildReminderToggle(screenWidth, screenHeight),

                        SizedBox(height: screenHeight * 0.03),

                        // Test button
                        _buildTestButton(screenWidth, screenHeight),

                        SizedBox(height: screenHeight * 0.04),

                        // 20-20-20 rule text
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
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
                          child: Text(
                            'Follow the 20-20-20 rule: Every 20 minutes, look at something 20 feet away for 20 seconds.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: screenWidth * 0.038,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 8,
                  left: 8,
                  child: SafeArea(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
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

  Widget _buildValueContainer(
      String label,
      String value,
      double screenWidth,
      double screenHeight,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF313050),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: screenHeight * 0.005),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderToggle(double screenWidth, double screenHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'remind me to break :',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        _isLoading
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              const Color(0xFF98C897),
            ),
          ),
        )
            : Switch(
          value: isReminderEnabled,
          onChanged: _handleReminderToggle,
          activeColor: const Color(0xFF98C897),
          inactiveThumbColor: const Color(0xFF5B5B82),
          inactiveTrackColor: const Color(0xFF313050),
        ),
      ],
    );
  }

  Widget _buildTestButton(double screenWidth, double screenHeight) {
    return ElevatedButton(
      onPressed: _testOverlay,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8B83B6),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.015,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.visibility, size: 20),
          SizedBox(width: screenWidth * 0.02),
          Text(
            'Test System Overlay',
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Your existing CircularTimer classes remain the same...
class CircularTimer extends StatefulWidget {
  final double radius;
  final double strokeWidth;
  final int value;
  final int maxValue;
  final Color color;
  final ValueChanged<int> onChanged;
  final bool showTicks;
  final String handleAsset;

  const CircularTimer({
    super.key,
    required this.radius,
    required this.strokeWidth,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.onChanged,
    required this.showTicks,
    required this.handleAsset,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer> {
  bool _isDragging = false;
  ui.Image? handleImage;

  @override
  void initState() {
    super.initState();
    _loadHandleImage();
  }

  Future<void> _loadHandleImage() async {
    final data = await DefaultAssetBundle.of(context).load(widget.handleAsset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    if (!mounted) return;
    setState(() {
      handleImage = frame.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: GestureDetector(
        onPanStart: (details) {
          _isDragging = true;
          _updateValueFromPosition(details.localPosition);
        },
        onPanUpdate: (details) {
          if (_isDragging) {
            _updateValueFromPosition(details.localPosition);
          }
        },
        onPanEnd: (details) {
          _isDragging = false;
        },
        child: CustomPaint(
          painter: CircularTimerPainter(
            radius: widget.radius,
            strokeWidth: widget.strokeWidth,
            value: widget.value,
            maxValue: widget.maxValue,
            color: widget.color,
            isDragging: _isDragging,
            showTicks: widget.showTicks,
            handleImage: handleImage,
          ),
        ),
      ),
    );
  }

  void _updateValueFromPosition(Offset position) {
    final center = Offset(widget.radius, widget.radius);
    final offset = position - center;

    double angle = math.atan2(offset.dx, -offset.dy);
    if (angle < 0) angle += 2 * math.pi;

    final normalizedAngle = angle / (2 * math.pi);
    int newValue = (normalizedAngle * widget.maxValue).round();

    if (newValue == 0) newValue = widget.maxValue;

    if (newValue != widget.value) {
      widget.onChanged(newValue);
    }
  }
}

class CircularTimerPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final int value;
  final int maxValue;
  final Color color;
  final bool isDragging;
  final bool showTicks;
  final ui.Image? handleImage;

  CircularTimerPainter({
    required this.radius,
    required this.strokeWidth,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.isDragging,
    required this.showTicks,
    this.handleImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Background circle
    canvas.drawCircle(center, radius - strokeWidth / 2, paint);

    // Filled arc
    paint.color = color;
    paint.strokeCap = StrokeCap.round;

    final sweepAngle = (value / maxValue) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );

    // Draw tick marks (only if showTicks is true)
    if (showTicks) {
      _drawTickMarks(canvas, center);
    }

    // Draw handle
    _drawHandle(canvas, center, sweepAngle);
  }

  void _drawTickMarks(Canvas canvas, Offset center) {
    final tickPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const tickCount = 60;
    for (int i = 0; i < tickCount; i++) {
      final angle = (i / tickCount) * 2 * math.pi - math.pi / 2;
      final tickLength = i % 5 == 0 ? 30.0 : 22.0;

      final startRadius = radius - strokeWidth / 2 - tickLength;
      final endRadius = radius - strokeWidth / 2;

      final startX = center.dx + startRadius * math.cos(angle);
      final startY = center.dy + startRadius * math.sin(angle);
      final endX = center.dx + endRadius * math.cos(angle);
      final endY = center.dy + endRadius * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        tickPaint,
      );
    }
  }

  void _drawHandle(Canvas canvas, Offset center, double sweepAngle) {
    final handleAngle = sweepAngle - math.pi / 2;
    final handleRadius = radius - strokeWidth / 2;

    final handleX = center.dx + handleRadius * math.cos(handleAngle);
    final handleY = center.dy + handleRadius * math.sin(handleAngle);

    if (handleImage != null) {
      final imageSize = 50.0;
      final imageRect = Rect.fromCenter(
        center: Offset(handleX, handleY),
        width: imageSize,
        height: imageSize,
      );
      canvas.drawImageRect(
        handleImage!,
        Rect.fromLTWH(
          0,
          0,
          handleImage!.width.toDouble(),
          handleImage!.height.toDouble(),
        ),
        imageRect,
        Paint(),
      );
    } else {
      canvas.drawCircle(
        Offset(handleX, handleY),
        15,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
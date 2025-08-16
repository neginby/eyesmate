import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  int selectedMinutes = 20;
  int selectedSeconds = 20;
  bool isReminderEnabled = true;

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
                // پس‌زمینه
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // محتوای صفحه
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        // لوگو + نام برنامه
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

                        // تایمر دایره‌ای
                        SizedBox(
                          height: screenHeight * 0.4,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // دایره بیرونی (دقیقه‌ها)
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
                                },
                                showTicks: true,
                                handleAsset: 'assets/images/eye_break_icon.png',
                              ),
                              // دایره داخلی (ثانیه‌ها)
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
                                },
                                showTicks: false,
                                handleAsset: 'assets/images/eye_break_icon.png',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // نمایش مقادیر
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

                        // سوئیچ یادآوری
                        _buildReminderToggle(screenWidth, screenHeight),

                        SizedBox(height: screenHeight * 0.04),

                        // متن قانون 20-20-20
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

                // دکمه بازگشت — آخر لیست children تا روی همه چیز باشد
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
        Switch(
          value: isReminderEnabled,
          onChanged: (value) {
            setState(() {
              isReminderEnabled = value;
            });
          },
          activeColor: const Color(0xFF98C897),
          inactiveThumbColor: const Color(0xFF5B5B82),
          inactiveTrackColor: const Color(0xFF313050),
        ),
      ],
    );
  }
}

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

    // دایره پس‌زمینه
    canvas.drawCircle(center, radius - strokeWidth / 2, paint);

    // بخش پر شده
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

    // شیارها (فقط اگر showTicks فعال باشه)
    if (showTicks) {
      _drawTickMarks(canvas, center);
    }

    // دسته
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

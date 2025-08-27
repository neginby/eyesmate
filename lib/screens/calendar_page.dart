import 'package:flutter/material.dart';
import '../services/usage_service.dart';

class CalendarScreenTimePage extends StatefulWidget {
  const CalendarScreenTimePage({super.key});

  @override
  State<CalendarScreenTimePage> createState() => _CalendarScreenTimePageState();
}

class _CalendarScreenTimePageState extends State<CalendarScreenTimePage> {
  late DateTime _currentMonth;
  DateTime? _selectedDay;
  final UsageService _usageService = UsageService();
  Map<DateTime, Duration> _screenTimeData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
    _loadScreenTimeData();
  }

  Future<void> _loadScreenTimeData() async {
    setState(() => _isLoading = true);

    try {
      // Check permission first
      final hasPermission = await _usageService.hasUsagePermission();
      if (!hasPermission) {
        setState(() => _isLoading = false);
        return;
      }

      final Map<DateTime, Duration> data = {};
      final now = DateTime.now();

      // Load data for the past 30 days
      for (int i = 0; i <= 30; i++) {
        final date = now.subtract(Duration(days: i));
        final dayKey = DateTime(date.year, date.month, date.day);

        try {
          // For now, only today's data is available from your service
          if (_isSameDay(date, now)) {
            final screenTime = await _usageService.getTotalScreenTimeToday();
            if (screenTime.inMinutes > 0) {
              data[dayKey] = screenTime;
            }
          }
          // For historical data, you would need to extend your UsageService
          // For demo purposes, adding some mock data for recent days
          else if (date.isAfter(now.subtract(const Duration(days: 7)))) {
            // Mock data for the past week (remove this in production)
            final mockMinutes = (i * 23 + 45) % 420; // Pseudo-random between 0-7 hours
            if (mockMinutes > 30) {
              data[dayKey] = Duration(minutes: mockMinutes);
            }
          }
        } catch (e) {
          print('Error loading data for ${date.toString()}: $e');
        }
      }

      setState(() {
        _screenTimeData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading screen time data: $e');
      setState(() => _isLoading = false);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    if (nextMonth.isBefore(now) || nextMonth.month == now.month) {
      setState(() {
        _currentMonth = nextMonth;
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '';
  }

  Color _getColorForScreenTime(Duration screenTime) {
    final minutes = screenTime.inMinutes;
    if (minutes == 0) return Colors.transparent;
    if (minutes < 60) return const Color(0xFF4CAF50); // Green - low usage
    if (minutes < 180) return const Color(0xFFFFC107); // Yellow - moderate usage
    if (minutes < 360) return const Color(0xFFFF9800); // Orange - high usage
    return const Color(0xFFF44336); // Red - very high usage
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Get the first day of the week for the month
    final startDay = firstDay.subtract(Duration(days: firstDay.weekday % 7));

    List<DateTime> days = [];
    DateTime currentDay = startDay;

    // Generate 6 weeks (42 days) to fill the calendar grid
    for (int i = 0; i < 42; i++) {
      days.add(currentDay);
      currentDay = currentDay.add(const Duration(days: 1));
    }

    return days;
  }

  bool _isCurrentMonth(DateTime day) {
    return day.month == _currentMonth.month && day.year == _currentMonth.year;
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return _isSameDay(day, now);
  }

  bool _isFutureDate(DateTime day) {
    final now = DateTime.now();
    return day.isAfter(DateTime(now.year, now.month, now.day));
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF011222),
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Column(
              children: [
                // Header
                _buildHeader(screenWidth),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Screen Time Calendar',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          'Past 30 days usage history',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: screenWidth * 0.04,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // Loading indicator
                        if (_isLoading)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(screenHeight * 0.05),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B83B6)),
                              ),
                            ),
                          )
                        else ...[
                          // Calendar
                          _buildCustomCalendar(screenWidth, screenHeight),

                          SizedBox(height: screenHeight * 0.03),

                          // Legend
                          _buildLegend(screenWidth),

                          SizedBox(height: screenHeight * 0.03),

                          // Selected day details
                          if (_selectedDay != null)
                            _buildSelectedDayDetails(screenWidth, screenHeight),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
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

          // Spacer
          Expanded(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 40,
                    height: 28,
                    child: Image.asset('assets/images/icon1.png', fit: BoxFit.contain),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'EyesMate',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Refresh button
          GestureDetector(
            onTap: _loadScreenTimeData,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF8B83B6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCalendar(double screenWidth, double screenHeight) {
    final days = _getDaysInMonth();

    return Container(
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Calendar header with month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _previousMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Text(
                '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * 0.02),

          // Days of week header
          Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.035,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ))
                .toList(),
          ),

          SizedBox(height: screenHeight * 0.01),

          // Calendar grid
          ...List.generate(6, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final dayNum = weekIndex * 7 + dayIndex;
                  if (dayNum >= days.length) {
                    return const Expanded(child: SizedBox());
                  }

                  final day = days[dayNum];
                  return Expanded(
                    child: _buildCalendarDay(day, screenWidth),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(DateTime day, double screenWidth) {
    final isCurrentMonth = _isCurrentMonth(day);
    final isSelected = _selectedDay != null && _isSameDay(day, _selectedDay!);
    final isToday = _isToday(day);
    final isFuture = _isFutureDate(day);
    final screenTime = _screenTimeData[DateTime(day.year, day.month, day.day)] ?? Duration.zero;
    final hasData = screenTime.inMinutes > 0 && !isFuture;

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth && !isFuture) {
          setState(() {
            _selectedDay = DateTime(day.year, day.month, day.day);
          });
        }
      },
      child: Container(
        height: screenWidth * 0.12,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? const Color(0xFF8B83B6)
              : isToday
              ? const Color(0xFF8B83B6).withOpacity(0.6)
              : hasData
              ? _getColorForScreenTime(screenTime).withOpacity(0.2)
              : Colors.transparent,
          border: hasData && !isSelected
              ? Border.all(color: _getColorForScreenTime(screenTime), width: 1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: isCurrentMonth
                    ? (isFuture ? Colors.white.withOpacity(0.3) : Colors.white)
                    : Colors.white.withOpacity(0.3),
                fontSize: screenWidth * 0.035,
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Jost',
              ),
            ),
            if (hasData && isCurrentMonth)
              Text(
                _formatDuration(screenTime),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: screenWidth * 0.025,
                  fontFamily: 'Jost',
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(double screenWidth) {
    return Container(
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usage Legend',
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Wrap(
            spacing: screenWidth * 0.04,
            runSpacing: screenWidth * 0.01,
            children: [
              _buildLegendItem('Low (< 1h)', const Color(0xFF4CAF50), screenWidth),
              _buildLegendItem('Moderate (1-3h)', const Color(0xFFFFC107), screenWidth),
              _buildLegendItem('High (3-6h)', const Color(0xFFFF9800), screenWidth),
              _buildLegendItem('Very High (> 6h)', const Color(0xFFF44336), screenWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color, double screenWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: screenWidth * 0.03,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDayDetails(double screenWidth, double screenHeight) {
    final selectedScreenTime = _screenTimeData[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? Duration.zero;
    final hasData = selectedScreenTime.inMinutes > 0;
    final isFuture = _isFutureDate(_selectedDay!);

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
          Row(
            children: [
              Text(
                'Selected Day',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (_isToday(_selectedDay!))
                Container(
                  margin: EdgeInsets.only(left: screenWidth * 0.02),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B83B6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Today',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: screenWidth * 0.025,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            '${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: screenWidth * 0.04,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          if (isFuture) ...[
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.white.withOpacity(0.6),
                  size: screenWidth * 0.06,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Future date - no data available',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.04,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ] else if (hasData) ...[
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: _getColorForScreenTime(selectedScreenTime),
                  size: screenWidth * 0.06,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Screen Time: ${_formatDuration(selectedScreenTime)}',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              _getUsageMessage(selectedScreenTime),
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: screenWidth * 0.035,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white.withOpacity(0.6),
                  size: screenWidth * 0.06,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'No screen time data available',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: screenWidth * 0.04,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _getUsageMessage(Duration screenTime) {
    final minutes = screenTime.inMinutes;
    if (minutes < 60) return 'Great! Low screen time usage.';
    if (minutes < 180) return 'Moderate usage - keep it balanced!';
    if (minutes < 360) return 'High usage - consider taking breaks.';
    return 'Very high usage - time for a digital detox!';
  }
}
import 'package:flutter/material.dart';
import 'reminder_page.dart';
import 'camera_page.dart';
import 'screen_time.dart';
import 'eye_care_tips.dart';

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF011222),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Logo + App name (top center)
                    Center(
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

                    SizedBox(height: screenHeight * 0.03),

                    /// Card with background image containing welcome + name + notif + quote
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.09),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image:
                          AssetImage('assets/images/quote_background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Row with welcome + name + notif icon
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome,',
                                      style: TextStyle(
                                        fontFamily: 'Jost',
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFDFDFDF),
                                      ),
                                    ),
                                    SizedBox(
                                        height: screenHeight * 0.005),
                                    Text(
                                      userName,
                                      style: TextStyle(
                                        fontFamily: 'Jost',
                                        fontSize: screenWidth * 0.06,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFFB0B0B0).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                    'assets/images/notification_icon.png'),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          /// Quote text
                          Text(
                            '"Give your eyes the care they deserve"',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    _buildFeatureButtons(context, screenWidth, screenHeight),

                    SizedBox(height: screenHeight * 0.06),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureButtons(
      BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: [
        _buildFeatureButton(
          context: context,
          title: 'Eye Break reminder',
          description:
          'set reminder and take regular break for your eyes',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page1()),
          ),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          imagePath: 'assets/images/eye_break_icon.png',
        ),
        SizedBox(height: screenHeight * 0.017),
        _buildFeatureButton(
          context: context,
          title: 'Eye-friendly distance',
          description:
          'Helps you avoid eye strain by keeping your screen at the proper distance',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page2()),
          ),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          imagePath: 'assets/images/distance_icon.png',
        ),
        SizedBox(height: screenHeight * 0.017),
        _buildFeatureButton(
          context: context,
          title: 'Screen Time Summary',
          description:
          'Track and review your screen usage over time',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page3()),
          ),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          imagePath: 'assets/images/screen.png',
        ),
        SizedBox(height: screenHeight * 0.017),
        _buildFeatureButton(
          context: context,
          title: 'Eye-Care Tips',
          description:
          'Suggest you a few moves to keep your eyes relaxed and feeling fresh',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Page4()),
          ),
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          imagePath: 'assets/images/tips_icon.png',
        ),
      ],
    );
  }

  Widget _buildFeatureButton({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: const Color(0xFF313050),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 75,
              height: 75,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFDFDFDF),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

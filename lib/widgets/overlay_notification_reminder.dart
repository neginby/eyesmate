import 'package:flutter/material.dart';

class OverlayNotificationCamera extends StatelessWidget {
  // final String title;
  // final String subtitle;
  // final VoidCallback? onDismiss;

  // const OverlayNotificationCamera({
  //   super.key,
  //   required this.title,
  //   required this.subtitle,
  //   this.onDismiss,
  // });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned.fill(
      child: Material(
        color: const Color(0x000c1c74).withOpacity(0.67),
        child: Stack(
          children: [
            // Background overlay with shine spots
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset('assets/images/background.png'),
                  ),
                ],
              ),
            ),

            // Main notification content
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Character/Icon placeholder - different style
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      child: Center(
                        child: Image.asset(
                          'assets/images/style.png',
                          fit: BoxFit.contain,
                        ),

                      ),
                    ),

                    // Title
                    Text(
                      "Take a short break!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.065,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Continuous screen time can cause eye strain.\nLook away for 20 seconds.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Close button (optional)
            // if (onDismiss != null)
              Positioned(
                top: 60,
                right: 20,
                child: GestureDetector(
                  // onTap: onDismiss,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
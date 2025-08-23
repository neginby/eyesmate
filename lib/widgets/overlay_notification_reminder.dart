import 'package:flutter/material.dart';

class OverlayNotificationReminder extends StatelessWidget {
  const OverlayNotificationReminder({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: const Color(0x000c1c74).withOpacity(0.67),
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // Background overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
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
                    // Character/Icon
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      child: Center(
                        child: Image.asset(
                          'assets/images/style.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if image not found
                            return Container(
                              width: screenWidth * 0.4,
                              height: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                color: const Color(0xFF98C897),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                                size: 80,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 30),

                    // Progress indicator or countdown (optional)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Rest your eyes...",
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class OverlayNotificationReminder extends StatelessWidget {
  // final String title;
  // final String subtitle;
  // final VoidCallback? onDismiss;
  //
  // const OverlayNotificationReminder({
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
                    // Character placeholder
                    SizedBox(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      child: Center(
                        child: Image.asset(
                          'assets/images/style1.png',
                          fit: BoxFit.contain,
                        ),

                      ),
                    ),

                    // Title
                    Text(
                      "Too close, buddy!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "Let's step back and protect those eyes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.3,
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
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
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
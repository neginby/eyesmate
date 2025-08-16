// File: /lib/screens/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveNameAndContinue() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Color(0xFF828282),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text.trim());

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(userName: _nameController.text.trim()),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving name. Please try again.'),
            backgroundColor: Colors.red,
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF011222),
      body: Stack(
        children: [
          // Background with shiny spots/stars
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top section with logo and welcome text
                          Column(
                            children: [
                              SizedBox(height: screenHeight * 0.06),

                              // Logo and app name
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    // decoration: BoxDecoration(
                                    //   color: const Color(0xFFB0B0B0).withOpacity(0.2),
                                    //   shape: BoxShape.circle,
                                    // ),
                                    // Use your logo image instead of the Icon
                                    child: Image.asset('assets/images/icon1.png'),
                                    // TODO: If image doesn't work, replace with Icon:
                                    // child: const Icon(
                                    //   Icons.visibility,
                                    //   color: Color(0xFFB0B0B0),
                                    //   size: 24,
                                    // ),
                                  ),

                                  SizedBox(width: screenWidth * 0.03),

                                  Text(
                                    'EyesMate',
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.08),

                              // Welcome text
                              Text(
                                'welcome to EyesMate',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Divider line
                              Container(
                                width: screenWidth * 0.8,
                                height: 1,
                                color: const Color(0xFFDADADA).withOpacity(0.3),
                              ),

                              SizedBox(height: screenHeight * 0.04),

                              // Description text
                              Text(
                                "Here's a quick overview of how this app helps protect your eyes:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFDFDFDF),
                                  height: 1.5,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.04),

                              // Features list
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFeatureItem(
                                    "– Keeps your phone at a safe distance from your face",
                                    screenWidth,
                                  ),
                                  _buildFeatureItem(
                                    "– Monitors your blinking to reduce eye strain",
                                    screenWidth,
                                  ),
                                  _buildFeatureItem(
                                    "– Reminds you to take breaks with customizable timers",
                                    screenWidth,
                                  ),
                                  _buildFeatureItem(
                                    "– Provides eye exercises to keep your vision healthy",
                                    screenWidth,
                                  ),
                                  _buildFeatureItem(
                                    "– Reduces blue light at night to help your eyes relax",
                                    screenWidth,
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Bottom section with input and button
                          Column(
                            children: [
                              SizedBox(height: screenHeight * 0.06),

                              // Call to action text
                              Text(
                                "Tell me your name and let's take care of your eyes!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Name input field
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: screenWidth * 0.04,
                                    color: const Color(0xFF828282),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'your name',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Jost',
                                      fontSize: screenWidth * 0.04,
                                      color: const Color(0xFFB0B0B0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                      vertical: screenHeight * 0.018,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              // Continue button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _saveNameAndContinue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6B73FF),
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.018,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Jost',
          fontSize: screenWidth * 0.037,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFDFDFDF),
          height: 1.4,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
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

                // Shiny spots overlay image - ADD YOUR SHINY SPOTS OVERLAY IMAGE HERE
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
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
                                  // size: 20,
                                ),
                              ),
                            ),
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
                            Container(width: 40),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Page title
                        Text(
                          'Eye Care Tips',
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Accordion sections
                        CustomAccordion(
                          title: "What is the 20–20–20 rule?",
                          content: "Every 20 minutes of screen time, look at something 20 feet (about 6 meters) away for at least 20 seconds.\n\nThis simple but effective rule helps reduce eye strain, dryness, and blurred vision caused by prolonged use of a mobile or computer screen. By regularly practicing this rule, you can prevent long-term eye damage.",
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        CustomAccordion(
                          title: "What is the optimal distance from the screen?",
                          content: "To reduce eye fatigue, it is recommended to keep a distance of 35 to 45 centimeters between your eyes and the screen.\n\nSitting too close causes your eyes to work harder to focus, leading to discomfort and strain. Proper distance not only improves comfort but also minimizes long-term visual stress.",
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        CustomAccordion(
                          title: "Blinking and dry eyes",
                          content: "While focusing on screens, we tend to blink less, which leads to dryness, burning, and irritation in the eyes.\n\nTry to blink consciously and regularly. Using reminders or eye drops (artificial tears) can help reduce dryness and improve comfort during screen time.",
                        ),

                        SizedBox(height: screenHeight * 0.04),
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

class CustomAccordion extends StatefulWidget {
  final String title;
  final String content;

  const CustomAccordion({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<CustomAccordion> createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
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
        children: [
          // Header (always visible)
          GestureDetector(
            onTap: _toggleExpansion,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _animation,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.04,
                0,
                screenWidth * 0.04,
                screenWidth * 0.04,
              ),
              child: Text(
                widget.content,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
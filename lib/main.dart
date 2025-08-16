// File: /lib/main.dart

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const EyesMateApp());
}

class EyesMateApp extends StatelessWidget {
  const EyesMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EyesMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Jost',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF011222),
      ),
      home: const SplashScreen(),
    );
  }
}
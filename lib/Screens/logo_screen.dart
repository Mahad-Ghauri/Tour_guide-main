import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tour_guide_application/Screens/onboarding_screen.dart'; // Import OnboardingScreen
import 'package:tour_guide_application/Authentication/auth_gate.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // This function handles the transition after a delay
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Display logo screen for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen(nextScreen: AuthGate())), // Pass next screen as AuthGate
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal, // Teal color for the background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add Image from assets
            Image.asset(
              'assets/images/logo.png', // Path to your logo image
              width: 150, // Width of the image
              height: 150, // Height of the image
            ),
            SizedBox(height: 20),
            Text(
              'Globe Guide', // Replace with your app name
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Welcome to Globe Guide', // App subtitle
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

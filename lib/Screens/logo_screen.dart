import 'package:flutter/material.dart';
import 'package:tour_guide_application/Screens/onboarding_screen.dart'; // Import OnboardingScreen
import 'package:tour_guide_application/Authentication/auth_gate.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.teal, // Set teal background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Centered Logo
              Image.asset('assets/images/logo.png', width: 150, height: 150),
              const SizedBox(height: 20),

              // Welcome Line
              const Text(
                'Your World, Our Guide',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Adjust text color for contrast
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

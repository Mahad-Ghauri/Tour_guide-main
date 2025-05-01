import 'package:flutter/material.dart';
import 'package:tour_guide_application/Screens/onboarding_screen.dart'; // Import OnboardingScreen
import 'package:tour_guide_application/Authentication/auth_gate.dart';

class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Logo
            Image.asset(
              'assets/images/logo.png',
              width: 150, // Adjust size as needed
              height: 150,
            ),
            const SizedBox(height: 20),

            // Welcome Line
            Text(
              'Your World, Our Guide',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tour_guide_application/authentication/auth_controller.dart';
import 'package:tour_guide_application/Screens/authentication/login_screen.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';
import 'package:tour_guide_application/Screens/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  static const String id = 'AuthGate';
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthenticationController().supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const HomeScreen();
        } else {
          return const OnboardingScreen(nextScreen: LoginScreen());
        }
      },
    );
  }
}

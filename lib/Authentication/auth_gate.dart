import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';
import 'package:tour_guide_application/Screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  static const String id = 'AuthGate';
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // If the user is logged in, navigate to HomeScreen
      return HomeScreen();
    } else {
      // If the user is not logged in, show a login screen
      return LoginScreen();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:tour_guide_application/Authentication/auth_controller.dart';
import 'package:tour_guide_application/Interface/interface.dart';
import 'package:tour_guide_application/Screens/login_screen.dart';

class AuthGate extends StatelessWidget {
  static const String id = 'AuthGate';
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthenticationController().supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(snapshot.error.toString())));
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return InterfaceScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

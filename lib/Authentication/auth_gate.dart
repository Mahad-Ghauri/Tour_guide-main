// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/Screens/home_screen.dart';
// import 'package:tour_guide_application/Screens/Authentication%20Screens/login_screen.dart';



import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/login_screen.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/reset_password_screen.dart';

class AuthGate extends StatefulWidget {
  static const String id = 'AuthGate';

  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Stream<AuthState> _authStream;

  @override
  void initState() {
    super.initState();

    /// 🔁 Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        // 🔐 Navigate to password reset screen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      return HomeScreen(); // ✅ User is logged in
    } else {
      return LoginScreen(); // ❌ User is not logged in
    }
  }
}

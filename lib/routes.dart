import 'package:flutter/material.dart';
import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Screens/calendar_view.dart';
import 'package:tour_guide_application/Screens/city_selection_screen.dart';
import 'package:tour_guide_application/Screens/login_screen.dart';
import 'package:tour_guide_application/Screens/signup_screen.dart';
import 'package:tour_guide_application/Screens/profile_screen.dart';

class Routes {
  // Route names as constants
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String calendar = '/calendar';
  static const String citySelection = '/city_selection';
  static const String profile = '/profile';
  static const String authGate = '/auth';

  // Route map for MaterialApp
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      calendar: (context) => const CalendarView(),
      citySelection: (context) => const CitySelectionScreen(),
      profile: (context) => const ProfileScreen(),
      authGate: (context) => const AuthGate(),
    };
  }

  // Handle dynamic routes or route parameters
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const AuthGate());

      // Add cases for routes that need custom transitions or parameters
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarView());

      case citySelection:
        return MaterialPageRoute(builder: (_) => const CitySelectionScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      // Add custom transitions for auth routes
      case login:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );

      case signup:
        return PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }

  // Navigation helper methods
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, signup);
  }

  static void navigateToCalendar(BuildContext context) {
    Navigator.pushNamed(context, calendar);
  }

  static void navigateToCitySelection(BuildContext context) {
    Navigator.pushNamed(context, citySelection);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }

  static void navigateToAuthGate(BuildContext context) {
    Navigator.pushReplacementNamed(context, authGate);
  }
}

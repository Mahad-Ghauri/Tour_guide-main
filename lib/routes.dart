import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Screens/create_album_screen.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Screens/city_selection_screen.dart';
import 'package:tour_guide_application/Screens/Authentication%20Screens/login_screen.dart';
import 'package:tour_guide_application/Screens/Authentication%20Screens/signup_screen.dart';
import 'package:tour_guide_application/Screens/Authentication%20Screens/profile_screen.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
import 'package:tour_guide_application/Screens/onboarding_screen.dart';
import 'package:tour_guide_application/Screens/hire_tour_guide.dart';
import 'package:tour_guide_application/Screens/location_entry_screen.dart';
import 'package:tour_guide_application/Screens/map_screen.dart';
import 'package:tour_guide_application/Screens/review_screen.dart';
import 'package:tour_guide_application/Screens/view_album_screen.dart';
import 'package:tour_guide_application/Screens/map_selection_Screen.dart';
import 'package:tour_guide_application/Screens/Chat%20Bot/chatbot_screen.dart';
import 'package:tour_guide_application/Screens/Authentication%20Screens/reset_password_screen.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/edit_profile_screen.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/help_center_screen.dart';


class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String calendar = '/calendar';
  static const String citySelection = '/city_selection';
  static const String map = '/map';
  static const String viewAlbum = '/view_album';
  static const String addPhoto = '/add_photo';
  static const String mapSelection = '/map_selection';
  static const String review = '/review';
  static const String locationEntry = '/location_entry';
  static const String hireTourGuide = '/hire_tour_guide';
  static const String profile = '/profile';
  static const String authGate = '/auth';
  static const String logo = '/logo';
  static const String onboarding = '/onboarding';
  static const String chatbot = '/chatbot';
  static const String resetPassword = '/reset_password';
  static const String editProfile = '/edit_profile';
  static const String helpCenter = '/help_center';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      signup: (context) => const SignUpScreen(),
      calendar: (context) => const CalendarView(),
      editProfile: (context) => const EditProfileScreen(),
      helpCenter: (context) => const HelpCenterScreen(),
      citySelection: (context) => const CitySelectionScreen(),
      map: (context) => MapScreen(placeName: 'Default Place', destination: LatLng(0.0, 0.0)),
      mapSelection: (context) => const MapSelectionScreen(),
      viewAlbum: (context) => const ViewAlbumScreen(),
      addPhoto: (context) => const CreateAlbumScreen(),
      review: (context) => const ReviewScreen(backgroundColor: Colors.transparent,),
      locationEntry: (context) => LocationEntryScreen(),
      hireTourGuide: (context) => const HireTourGuideScreen(),
      profile: (context) => const ProfileScreen(),
      authGate: (context) => const AuthGate(),
      logo: (context) => const LogoScreen(),
      onboarding: (context) => OnboardingScreen(nextScreen: const AuthGate()),
      chatbot: (context) => const ChatbotScreen(),
      resetPassword: (context) => const ResetPasswordScreen(),
    };
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const LogoScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarView());
      case citySelection:
        return MaterialPageRoute(builder: (_) => const CitySelectionScreen());
      case map:
        return MaterialPageRoute(builder: (_) => MapScreen(placeName: 'Default Place', destination: LatLng(0.0, 0.0)));
      case viewAlbum:
        final args = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ViewAlbumScreen(),
        );
      case addPhoto:
        return MaterialPageRoute(builder: (_) => const CreateAlbumScreen());
      case mapSelection:
        return MaterialPageRoute(builder: (_) => const MapSelectionScreen());
      case review:
        return MaterialPageRoute(builder: (_) => const ReviewScreen(backgroundColor: Colors.transparent,));
      case locationEntry:
       return MaterialPageRoute(builder: (_) => LocationEntryScreen());
      case hireTourGuide:
        return MaterialPageRoute(builder: (_) => const HireTourGuideScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case logo:
        return MaterialPageRoute(builder: (_) => const LogoScreen());
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(nextScreen: const AuthGate()),
        );
      case login:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      case signup:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      case chatbot:
        return MaterialPageRoute(builder: (_) => const ChatbotScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.pushReplacementNamed(context, signup);
  }

  static void navigateToViewAlbum(BuildContext context) {
    Navigator.pushNamed(context, viewAlbum);
  }
  static void navigateToEditProfile(BuildContext context) {
    Navigator.pushNamed(context, editProfile);
  }
  static void navigateToHelpCenter(BuildContext context) {
    Navigator.pushNamed(context, helpCenter);
  }
  static void navigateToCalendar(BuildContext context) {
    Navigator.pushNamed(context, calendar);
  }

  static void navigateToMapSelection(BuildContext context) {
    Navigator.pushNamed(context, mapSelection);
  }
  static void navigateToresetPassword(BuildContext context) {
    Navigator.pushNamed(context, resetPassword);
  }
  static void navigateToCitySelection(BuildContext context) {
    Navigator.pushNamed(context, citySelection);
  }

  static void navigateToMap(BuildContext context) {
    Navigator.pushNamed(context, map);
  }

  static void navigateToAddPhoto(BuildContext context) {
    Navigator.pushNamed(context, addPhoto);
  }

  static void navigateToLocationEntry(BuildContext context, LatLng pickedLocation) {
    Navigator.pushNamed(
      context,
      locationEntry,
      arguments: pickedLocation,
    );
  }

  static void navigateToHireTourGuide(BuildContext context) {
    Navigator.pushNamed(context, hireTourGuide);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, profile);
  }

  static void navigateToOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, onboarding);
  }

  static void navigateToReview(BuildContext context) {
    Navigator.pushNamed(context, review);
  }

  static void navigateToChatbot(BuildContext context) {
    Navigator.pushNamed(context, chatbot);
  }
}
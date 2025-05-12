import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:tour_guide_application/Authentication/auth_controller.dart';
import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Screens/Authentication%20Screens/auth_gate.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Controllers/album_controller.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/Controllers/ChatBot%20Controller/chatbot_controller.dart';
import 'package:tour_guide_application/routes.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
// import 'package:tour_guide_application/ChatbotModule/View/chatbot_interface.dart';
// import 'package:tour_guide_application/ChatbotModule/theme/chatbot_theme.dart' hide lightMode, darkMode;
import 'package:tour_guide_application/Components/bottom_nav_bar.dart';
import 'package:tour_guide_application/Screesns/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/help_center_screen.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    log("Initializing Supabase...");
    await Supabase.initialize(
      url: 'https://wkwhjswjekqlugndxegl.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indrd2hqc3dqZWtxbHVnbmR4ZWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0Nzg3MTQsImV4cCI6MjA1ODA1NDcxNH0.VNb3DAheO5YBx0rtSrk0S9vh13MI3TQlN0VnICQRAJk',
      debug: true,
    );
    log("✅ Supabase Initialized Successfully");
    runApp(const MyApp());
  } catch (e) {
    log("❌ Supabase initialization error: $e");
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Failed to initialize the app. Please try again later.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationController()),
        ChangeNotifierProvider(create: (_) => CalendarController()),
        ChangeNotifierProvider(create: (_) => CountryController()),
        ChangeNotifierProvider(create: (_) => AlbumController()),
        ChangeNotifierProvider(create: (_) => ChatbotController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tour Guide',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: AppColors.lightBackground,
          fontFamily: 'Poppins',
        ),
        themeMode: ThemeMode.system,
        home: const AuthGate(),
        routes: Routes.getRoutes(),
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}

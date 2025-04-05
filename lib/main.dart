// ignore_for_file: unused_field

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Authentication/auth_controller.dart';
import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';

// import 'package:tour_guide_application/Controllers/city_controller.dart';
// import 'package:tour_guide_application/Screens/logo_screen.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/Screens/calendar_view.dart';
import 'package:tour_guide_application/Screens/city_selection_screen.dart';
import 'package:tour_guide_application/consts.dart'; // Add your City Selection screen import

// Main app initialization
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    log("Initializing Supabase...");
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true, // Enable debug mode to see detailed logs
    );
    log("✅ Supabase Initialized Successfully");
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Supabase initialization error: $e');
    // You might want to show an error screen here instead of crashing
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tour Guide',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008080)),
          useMaterial3: true,
        ),
        home: const AuthGate(),
        routes: {
          '/calendar': (context) => const CalendarView(),
          // '/map': (context) => MapScreen(), // Commented out MapScreen route
          '/city_selection':
              (context) =>
                  const CitySelectionScreen(), // Add the city selection screen route
        },
      ),
    );
  }
}

// Example HomeScreen where you can trigger navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the city selection screen
            Navigator.pushNamed(context, '/city_selection');
          },
          child: const Text('Go to City Selection'),
        ),
      ),
    );
  }
}

// CalendarScreen for navigation example
class CalendarScreen extends StatelessWidget {
  final CalendarController _calendarController = CalendarController();

  CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar Screen')),
      body: Center(child: const Text('Calendar functionality goes here')),
    );
  }
}

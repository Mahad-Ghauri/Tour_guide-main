import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';

import 'package:tour_guide_application/Controllers/city_controller.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/Screens/calendar_view.dart';
import 'package:tour_guide_application/Screens/city_selection_screen.dart'; // Add your City Selection screen import

// Main app initialization
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    log("Initializing Supabase...");
    await Supabase.initialize(
      url: 'https://wkwhjswjekqlugndxegl.supabase.co',
      anonKey: 'your_anon_key', // Replace with your actual anon key
    );
    log("Supabase Initialized");
    runApp(const MainApp());
  } catch (error, stackTrace) {
    log("Error initializing Supabase: ${error.toString()}");
    log("StackTrace: ${stackTrace.toString()}");
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CountryController>(
          create: (_) => CountryController(),
        ),
        // Uncomment and include CityController if needed
        // ChangeNotifierProvider<CityController>(create: (_) => CityController()),
        ChangeNotifierProvider<CalendarController>(
          create: (_) => CalendarController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LogoScreen(),
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

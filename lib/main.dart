import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Controllers/city_controller.dart';

import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/Screens/calendar_view.dart';
import 'package:tour_guide_application/Screens/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    log("Initializing Supabase...");
    await Supabase.initialize(
      url: 'https://wkwhjswjekqlugndxegl.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indrd2hqc3dqZWtxbHVnbmR4ZWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0Nzg3MTQsImV4cCI6MjA1ODA1NDcxNH0.VNb3DAheO5YBx0rtSrk0S9vh13MI3TQlN0VnICQRAJk', // Replace with your actual anon key
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
        ChangeNotifierProvider<CityController>(create: (_) => CityController()),
        ChangeNotifierProvider<CalendarController>(
          create: (_) => CalendarController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LogoScreen(),
        routes: {
          '/calendar': (context) => const CalendarView(),
          '/map': (context) => MapScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/calendar');
          },
          child: const Text('Go to Calendar'),
        ),
      ),
    );
  }
}

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

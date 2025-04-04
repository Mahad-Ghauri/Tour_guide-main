import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Controllers/city_controller.dart';
import 'package:tour_guide_application/consts.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/Screens/calendar_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(url: url, anonKey: anonKey);
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
        home: LogoScreen(),
        routes: {'/calendar': (context) => CalendarScreen()},
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
      appBar: AppBar(title: Text('Calendar Screen')),
      body: Center(child: Text('Calendar functionality goes here')),
    );
  }
}

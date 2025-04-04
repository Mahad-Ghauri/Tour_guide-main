// main.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Controllers/city_controller.dart';
import 'package:tour_guide_application/consts.dart';
// import 'package:tour_guide_application/Screens/home_screen.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
// import 'package:tour_guide_application/Screens/onboarding_screen.dart';
import 'package:tour_guide_application/controllers/calendar_controller.dart';
// import 'package:tour_guide_application/Screens/logo_screen.dart'; // Import LogoScreen
// import 'package:tour_guide_application/Screens/onboarding_screen.dart';
// import 'package:tour_guide_application/Screens/country_selection_screen.dart'; // Import CountrySelectionScree
// import 'package:tour_guide_application/Screens/city_selection_screen.dart';
// import 'package:tour_guide_application/Controllers/city_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  try {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    log("Supabase Initialized");
    runApp(MainApp());
  } catch (error, stackTrace) {
    log("Error initializing Supabase: ${error.toString()}");
    log("StackTrace: ${stackTrace.toString()}");
  }

  await Supabase.initialize(url: url, anonKey: anonKey)
      .then((value) {
        log("Supabase Initialized");
        runApp(MainApp());
      })
      .onError((error, stackTrace) {
        log("Error initializing Supabase: ${error.toString()}");
        log("StackTrace: ${stackTrace.toString()}");
      });

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountryController()),
        ChangeNotifierProvider(
          create: (_) => CityController(),
        ), // Added CityController here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LogoScreen(),
        routes: {
          '/calendar': (context) => CalendarScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/calendar');
          },
          child: Text('Go to Calendar'),
        ),
      ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  final CalendarController _calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Screen'),
      ),
      body: Center(
        child: Text('Calendar functionality goes here'),
      ),
    );
  }
}


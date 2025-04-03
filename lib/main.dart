// main.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Controllers/city_controller.dart';
import 'package:tour_guide_application/consts.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart'; // Import LogoScreen
import 'package:tour_guide_application/Screens/onboarding_screen.dart';
import 'package:tour_guide_application/Screens/country_selection_screen.dart'; // Import CountrySelectionScree
import 'package:tour_guide_application/Screens/city_selection_screen.dart';
// Import CitySelectionScreen
import 'package:tour_guide_application/Controllers/city_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    final session = Supabase.instance.client.auth.currentSession;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountryController()),
        ChangeNotifierProvider(
          create: (_) => CityController(),
        ), // Added CityController here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LogoScreen(), // Set LogoScreen as the first screen
      ),
    );
  }
}

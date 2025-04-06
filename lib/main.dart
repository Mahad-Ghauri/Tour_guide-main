// ignore_for_file: unused_field

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import 'package:tour_guide_application/Authentication/auth_controller.dart';
// import 'package:tour_guide_application/Authentication/auth_gate.dart';
import 'package:tour_guide_application/Controllers/country_controllers.dart';
import 'package:tour_guide_application/Controllers/calendar_controller.dart';
import 'package:tour_guide_application/consts.dart';
import 'package:tour_guide_application/routes.dart';
import 'package:tour_guide_application/Screens/logo_screen.dart';
import 'package:tour_guide_application/Screens/hire_tour_guide.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tour Guide',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008080)),
          useMaterial3: true,
        ),
        home: const LogoScreen(),
        routes: Routes.getRoutes(),
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthenticationController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNavigationCard(
                context,
                'City Selection',
                'Choose your destination',
                Icons.location_city,
                () => Routes.navigateToCitySelection(context),
              ),
              const SizedBox(height: 16),
              _buildNavigationCard(
                context,
                'Calendar',
                'View and manage events',
                Icons.calendar_today,
                () => Routes.navigateToCalendar(context),
              ),
              const SizedBox(height: 16),
              _buildNavigationCard(
                context,
                'Profile',
                'View and edit your profile',
                Icons.person,
                () => Routes.navigateToProfile(context),
              ),
              const SizedBox(height: 16),
              // Added Hire a Guide navigation
              _buildNavigationCard(
                context,
                'Hire a Guide',
                'Find and hire a tour guide',
                Icons.person_add,
                () => Routes.navigateToHireTourGuide(context),
                // New navigation to Hire Guide
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(subtitle, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
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
      body: const Center(child: Text('Calendar functionality goes here')),
    );
  }
}

// Profile Screen for navigation
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Profile information will be displayed here'),
      ),
    );
  }
}

// New Hire Guide Screen for navigation
class HireGuideScreen extends StatelessWidget {
  const HireGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hire a Guide')),
      body: const Center(child: Text('Hire a tour guide here')),
    );
  }
}

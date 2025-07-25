import 'package:flutter/material.dart';
import 'package:tour_guide_application/Components/bottom_nav_bar.dart';
import 'package:tour_guide_application/Screens/home_screen.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_screen.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/profile_screen.dart';
import 'package:tour_guide_application/Screens/Chat%20Bot/chatbot_screen.dart';
import 'package:tour_guide_application/Utilis/Theme/chatbot_theme.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton:
          _currentIndex == 0
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                  );
                },
                backgroundColor: AppColors.primaryTeal,
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                ),
              )
              : _currentIndex == 1
              ? FloatingActionButton(
                onPressed: () {
                  // Show add event dialog
                  final calendarScreen = _screens[1] as CalendarScreen;
                  calendarScreen.showAddEventDialog(context);
                },
                backgroundColor: AppColors.primaryTeal,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
    );
  }
}

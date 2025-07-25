import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF559CB2),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, const Color(0xFFE0F2F7)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // Added SingleChildScrollView to make the screen scrollable
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.info_outline, size: 50, color: const Color(0xFF559CB2)),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Tour Guide Application',
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF559CB2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Version: 1.0.0',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'About the App',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF559CB2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The Tour Guide Application is designed to help users explore and plan their tours effectively. '
                  'With features like profile management, security settings, and a help center, this app ensures a seamless experience for travelers.',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Developers',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF559CB2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1. Mahneen Mirza\n2. Abdullah Nadeem',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Contact Us',
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF559CB2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: mahneenmirza4@gmail.com\nPhone: +123 456 7890', // Updated email
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: abdulah99.nadeem1@gmail.com\nPhone: +123 456 7890', // Updated email
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

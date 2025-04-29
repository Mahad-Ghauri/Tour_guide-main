import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tour_guide_application/ChatbotModule/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Screens/country_selection_screen.dart';
import 'package:tour_guide_application/Screens/create_album_screen.dart';
import 'package:tour_guide_application/Screens/hire_tour_guide.dart';
import 'package:tour_guide_application/Screens/map_selection_Screen.dart';
import 'package:tour_guide_application/Screens/review_screen.dart';

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Services",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          AnimationLimiter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 400),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children: [
                      _buildServiceIcon(
                        context,
                        Icons.public,
                        "Select Country",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CountrySelectionScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceIcon(
                        context,
                        Icons.people_alt,
                        "Hire Guide",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HireTourGuideScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceIcon(context, Icons.map, "Map", () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MapSelectionScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 200),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children: [
                      _buildServiceIcon(
                        context,
                        Icons.photo_camera,
                        "Add Photos",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateAlbumScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceIcon(
                        context,
                        Icons.rate_review,
                        "Reviews",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReviewScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceIcon(
                        context,
                        Icons.calendar_today,
                        "Calendar",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalendarView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primaryTeal, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';

class HeroCarousel extends StatefulWidget {
  final List<String> imageList;
  final List<Map<String, dynamic>> journeyCards;
  final PageController pageController;
  final int currentIndex;
  final Function(int) onPageChanged;

  const HeroCarousel({
    super.key,
    required this.imageList,
    required this.journeyCards,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              "Explore Destinations",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: widget.pageController,
              itemCount: widget.journeyCards.length,
              onPageChanged: widget.onPageChanged,
              itemBuilder: (context, index) {
                final destination = widget.journeyCards[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: widget.currentIndex == index ? 0 : 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      destination['image'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.journeyCards.length,
              (index) => _buildDotIndicator(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: widget.currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color:
            widget.currentIndex == index
                ? AppColors.primaryTeal
                : AppColors.greyText.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

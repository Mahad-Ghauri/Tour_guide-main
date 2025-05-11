import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';

class TrendingSection extends StatelessWidget {
  final List<Map<String, dynamic>> journeyCards;

  const TrendingSection({super.key, required this.journeyCards});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> trendingDestinations = [
      {
        'name': 'Tomb of  Shah Rukn-e-Alam',
        'image': 'assets/images/destination1.jpg',
      },
      {
        'name': 'Walled City Ghanta Ghar',
        'image': 'assets/images/destination2.jpg',
      },
      {
        'name': 'Shrine of Shah Yusuf Gardezi',
        'image': 'assets/images/destination3.jpg',
      },
      {
        'name': 'Khooni Burj',
        'image': 'assets/images/destination4.jpg',
      },
      {
        'name': 'Haram Gate',
        'image': 'assets/images/destination5.jpg',
      },
      {
        'name': 'Chaman Zar e Askari Park Multan',
        'image': 'assets/images/destination6.jpg',
      },
      {
        'name': 'Multan Arts Council',
        'image': 'assets/images/destination7.jpg',
      },
      {
        'name': 'DHA ZOO',
        'image': 'assets/images/destination8.jpg',
      },
      {
        'name': 'Kashmir Park DHA',
        'image': 'assets/images/destination9.jpg',
      },
      {
        'name': 'Mall of Multan',
        'image': 'assets/images/destination10.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trending Now",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: trendingDestinations.length,
              itemBuilder: (context, index) {
                final card = trendingDestinations[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          card['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.6],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Text(
                            card['name'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

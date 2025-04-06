// lib/screens/home_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tour_guide_application/Components/category_icon.dart';
import 'package:tour_guide_application/Components/journey_card.dart';
import 'package:tour_guide_application/Screens/country_selection_screen.dart';
import 'package:tour_guide_application/Screens/calendar_view.dart';
import 'package:tour_guide_application/Screens/hire_tour_guide.dart';
import 'package:tour_guide_application/Screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;
  Timer? _timer;
  int _bottomNavIndex = 0;

  final List<String> imageList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];

  final List<Map<String, String>> journeyCards = [
    {
      'name': 'Mount Bromo',
      'rating': '4.9',
      'price': '\$150/pax',
      'image': 'assets/images/image1.jpg',
    },
    {
      'name': 'Labengki Sombori',
      'rating': '4.8',
      'price': '\$250/pax',
      'image': 'assets/images/image2.jpg',
    },
    {
      'name': 'Raja Ampat',
      'rating': '4.9',
      'price': '\$300/pax',
      'image': 'assets/images/image3.jpg',
    },
    {
      'name': 'Bali',
      'rating': '4.7',
      'price': '\$200/pax',
      'image': 'assets/images/image4.jpg',
    },
    {
      'name': 'Yogyakarta',
      'rating': '4.8',
      'price': '\$180/pax',
      'image': 'assets/images/image5.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % imageList.length;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onBottomNavItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CalendarView()),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildImageCarousel(),
                  _buildCategoryIcons(context),
                  _buildJourneyTogetherSection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome Back!',
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.teal),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      style: GoogleFonts.urbanist(),
      decoration: InputDecoration(
        hintText: "Where to go?",
        hintStyle: GoogleFonts.urbanist(color: Colors.grey[400]),
        prefixIcon: const Icon(Icons.search, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        height: 250,
        child: PageView.builder(
          controller: _pageController,
          itemCount: imageList.length,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            double scale = (_currentIndex == index) ? 1.0 : 0.8;
            double opacity = (_currentIndex == index) ? 1.0 : 0.4;

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imageList[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CategoryIcon(
            icon: Icons.public,
            label: "Select Country",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CountrySelectionScreen(),
                ),
              );
            },
          ),
          CategoryIcon(
            icon: Icons.public,
            label: "Hire Tour Guide",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HireTourGuideScreen(),
                ),
              );
            },
          ),
          CategoryIcon(
            icon: Icons.rate_review,
            label: "Reviews",
            onTap: () {
              // TODO: Implement reviews
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyTogetherSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Journey together",
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement see all
                },
                child: Text(
                  "See all",
                  style: GoogleFonts.urbanist(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: journeyCards.length,
              itemBuilder: (context, index) {
                final card = journeyCards[index];
                return JourneyCard(
                  name: card['name']!,
                  rating: card['rating']!,
                  price: card['price']!,
                  imageUrl: card['image']!,
                  onTap: () {
                    // TODO: Implement journey details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.urbanist(),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: _onBottomNavItemTapped,
      ),
    );
  }
}

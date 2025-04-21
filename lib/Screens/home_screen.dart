// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Components/category_icon.dart';
import 'package:tour_guide_application/Components/journey_card.dart';
import 'package:tour_guide_application/Screens/add_photo_screen.dart';
import 'package:tour_guide_application/Screens/login_screen.dart';
import 'package:tour_guide_application/Screens/country_selection_screen.dart';
import 'package:tour_guide_application/Screens/calendar_view.dart';
import 'package:tour_guide_application/Screens/hire_tour_guide.dart';
import 'package:tour_guide_application/Screens/profile_screen.dart';
import 'package:tour_guide_application/Screens/review_screen.dart';

final supabase = Supabase.instance.client;

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;
  Timer? _timer;
  int _bottomNavIndex = 0;
  List<Map<String, dynamic>> _reviews = [];
  bool isLoading = true;
  String? errorMessage;

  final List<String> imageList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];

  final List<Map<String, String>> journeyCards = [
    {'name': 'Mount Bromo', 'rating': '4.9', 'price': '\$150/pax', 'image': 'assets/images/image1.jpg'},
    {'name': 'Labengki Sombori', 'rating': '4.8', 'price': '\$250/pax', 'image': 'assets/images/image2.jpg'},
    {'name': 'Raja Ampat', 'rating': '4.9', 'price': '\$300/pax', 'image': 'assets/images/image3.jpg'},
    {'name': 'Bali', 'rating': '4.7', 'price': '\$200/pax', 'image': 'assets/images/image4.jpg'},
    {'name': 'Yogyakarta', 'rating': '4.8', 'price': '\$180/pax', 'image': 'assets/images/image5.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _fetchReviews();
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

  Future<void> _fetchReviews() async {
    try {
      final response = await supabase
          .from('reviews')
          .select('username, comment, rating, avatar_url, inserted_at')
          .order('inserted_at', ascending: false);
      setState(() {
        _reviews = List<Map<String, dynamic>>.from(response);
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error loading reviews: $e';
      });
    }
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
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarView()));
      } else if (index == 2) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
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
                  _buildReviewSection(),
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
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Welcome Back!',
                  style: GoogleFonts.urbanist(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                  const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.teal)),
                ],
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemBuilder: (context, index) {
            final scale = (_currentIndex == index) ? 1.0 : 0.8;
            final opacity = (_currentIndex == index) ? 1.0 : 0.4;

            return AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(imageList[index], fit: BoxFit.cover),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryIcon(icon: Icons.public, label: "Select Country", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CountrySelectionScreen()));
              }),
              CategoryIcon(icon: Icons.people_alt, label: "Hire Tour Guide", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const HireTourGuideScreen()));
              }),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryIcon(icon: Icons.map, label: "Map", onTap: () {}),
              CategoryIcon(icon: Icons.photo_camera, label: "Add Photos", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPhotoScreen()));
              }),
              CategoryIcon(icon: Icons.rate_review, label: "Reviews", onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewScreen()));
              }),
            ],
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
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Journey together",
                style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
            TextButton(
              onPressed: () {},
              child: Text("See all", style: GoogleFonts.urbanist(color: Colors.teal, fontWeight: FontWeight.w600)),
            ),
          ]),
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
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("User Reviews",
                  style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal)),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewScreen()));
                },
                child: Text("Add Review", style: GoogleFonts.urbanist(color: Colors.teal, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage != null)
            Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
          else if (_reviews.isEmpty)
            const Center(child: Text('No reviews yet'))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];
                final username = review['username'] ?? 'Anonymous';
                final comment = review['comment'] ?? 'No comment';
                final rating = (review['rating'] as num?)?.toDouble() ?? 0.0;
                final avatarUrl = review['avatar_url'] as String?;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text(username, style: GoogleFonts.urbanist(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment, style: GoogleFonts.urbanist()),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            5,
                            (star) {
                              if (star < rating.floor()) {
                                return const Icon(Icons.star, color: Colors.amber, size: 20);
                              } else if (star < rating) {
                                return const Icon(Icons.star_half, color: Colors.amber, size: 20);
                              } else {
                                return const Icon(Icons.star_border, color: Colors.amber, size: 20);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.urbanist(),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      onTap: _onBottomNavItemTapped,
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Components/header_component.dart';
import 'package:tour_guide_application/Components/hero_carousel.dart';
import 'package:tour_guide_application/Components/category_tabs.dart';
import 'package:tour_guide_application/Components/trending_section.dart';
import 'package:tour_guide_application/Components/category_icons.dart';
import 'package:tour_guide_application/Components/journey_together_section.dart';
import 'package:tour_guide_application/Components/review_section.dart';
import 'package:tour_guide_application/Screens/Chat%20Bot/chatbot_screen.dart';
import 'package:tour_guide_application/Components/bottom_nav_bar.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Screens/Authentication Screens/profile_screen.dart';


final supabase = Supabase.instance.client;

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  late final TabController _tabController;
  int _currentIndex = 0;
  Timer? _timer;
  List<Map<String, dynamic>> _reviews = [];
  bool isLoading = true;
  String? errorMessage;
  final ScrollController _scrollController = ScrollController();

  final List<String> imageList = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
    'assets/images/image4.jpg',
    'assets/images/image5.jpg',
  ];

  final List<Map<String, dynamic>> journeyCards = [
    {
      'name': 'Mount Bromo',
      'rating': '4.9',
      'price': '\$150/pax',
      'image': 'assets/images/image1.jpg',
      'location': 'East Java, Indonesia',
      'tags': ['Mountain', 'Hiking'],
    },
    {
      'name': 'Labengki Sombori',
      'rating': '4.8',
      'price': '\$250/pax',
      'image': 'assets/images/image2.jpg',
      'location': 'Southeast Sulawesi, Indonesia',
      'tags': ['Island', 'Beach'],
    },
    {
      'name': 'Raja Ampat',
      'rating': '4.9',
      'price': '\$300/pax',
      'image': 'assets/images/image3.jpg',
      'location': 'West Papua, Indonesia',
      'tags': ['Diving', 'Marine Life'],
    },
    {
      'name': 'Bali',
      'rating': '4.7',
      'price': '\$200/pax',
      'image': 'assets/images/image4.jpg',
      'location': 'Bali, Indonesia',
      'tags': ['Beach', 'Culture', 'Surfing'],
    },
    {
      'name': 'Yogyakarta',
      'rating': '4.8',
      'price': '\$180/pax',
      'image': 'assets/images/image5.jpg',
      'location': 'Central Java, Indonesia',
      'tags': ['Temple', 'Culture', 'History'],
    },
  ];

  final List<String> _categories = [
    'Popular',
    'Adventure',
    'Beach',
    'Mountain',
    'Culture',
    'Food',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
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
          .order('inserted_at', ascending: false)
          .limit(3);
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
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) => false,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const HeaderComponent(),
                    HeroCarousel(
                      imageList: imageList,
                      journeyCards: journeyCards,
                      pageController: _pageController,
                      currentIndex: _currentIndex,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                    ),
                    CategoryTabs(
                      tabController: _tabController,
                      categories: _categories,
                    ),
                    TrendingSection(journeyCards: journeyCards),
                    const CategoryIcons(),
                    JourneyTogetherSection(journeyCards: journeyCards),
                    ReviewSection(
                      reviews: _reviews,
                      isLoading: isLoading,
                      errorMessage: errorMessage,
                      onRefresh: _fetchReviews,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatbotScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 85, 156, 178),
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ✅ Show the bottom navigation bar
      bottomNavigationBar: BottomNavBar(
  currentIndex: 0, // Home tab is active
  onTap: (index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CalendarView()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  },
),
    );
  }
}

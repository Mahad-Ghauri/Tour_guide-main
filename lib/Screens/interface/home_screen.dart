import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/Calendar/calendar_view.dart';
import 'package:tour_guide_application/Utilis/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Components/header_component.dart';
import 'package:tour_guide_application/Components/hero_carousel.dart';
import 'package:tour_guide_application/Components/category_tabs.dart';
import 'package:tour_guide_application/Components/trending_section.dart';
import 'package:tour_guide_application/Components/category_icons.dart';
import 'package:tour_guide_application/Components/journey_together_section.dart';
import 'package:tour_guide_application/Components/review_section.dart';
import 'package:tour_guide_application/Screens/Chat%20Bot/chatbot_screen.dart';
import 'package:tour_guide_application/Components/bottom_nav_bar.dart';
import 'package:tour_guide_application/Screens/interface/profile_screen.dart';
//

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

      'name': 'Kashmir ',
      'rating': '4.9',
      'price': 'Rs 150000/max',
      'image': 'assets/images/kashmir.jpg',
      'location': 'North West, Pakistan',
      'tags': ['Mountain', 'Hiking'],
    },
    {
      'name': 'Lahore',
      'rating': '4.8',
      'price': 'RS 10000/max',
      'image': 'assets/images/lahore1.jpg',
      'location': 'North East, Pakistan',
      'tags': ['Old Lahore', 'History'],
    },
    {
      'name': 'Skardu',
      'rating': '4.9',
      'price': 'Rs 300000/max',
      'image': 'assets/images/skardu.jpg',
      'location': 'Northen, Pakistan',
      'tags': ['Mountains', 'Paragliding'],
    },
    {
      'name': 'Babusar Top',
      'rating': '4.7',
      'price': 'Rs 200000/max',
      'image': 'assets/images/babusartop.jpg',
      'location': 'North-East, Pakistan',
      'tags': ['Pasu Cones','Surfing'],
    },
    {
      
      'name': 'Fairy Meadows',
      'rating': '4.9',
      'price': 'Rs 15,000/max',
      'image': 'assets/images/fairymeadows.jpg',
      'location': 'Azad Kashmir, Pakistan',
      'tags': ['Mountain', 'Hiking'],
    },
    {
      'name': 'Hunza Valley',
      'rating': '4.8',
      'price': 'Rs 20,000/max',
      'image': 'assets/images/hunza.jpg',
      'location': 'Gilgit-Baltistan, Pakistan',
      'tags': ['Pasu Cones','Nature'],
    },
    {
      'name': 'Peshawar',
      'rating': '4.9',
      'price': 'Rs 18,000/max',
      'image': 'assets/images/peshawar.jpg',
      'location': 'Khyber Pakhtunkhwa, Pakistan',
      'tags': ['Architecture', 'Culture'],
    },
    {
      'name': 'Swat Valley',
      'rating': '4.7',
      'price': 'Rs 12,000/max',
      'image': 'assets/images/swatvalley.jpg',
      'location': 'Kalam Valley, Pakistan',
      'tags': ['Valley', 'Culture', 'History'],
    },
    {
      'name': 'Mushkpuri Top',
      'rating': '4.8',
      'price': 'Rs 5,000/max',
      'image': 'assets/images/mushkuritop.jpg',
      'location': 'Nothern Pakistan, Pakistan',
      'tags': ['Hiking', 'Mountains'],
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

  final List<Map<String, dynamic>> exploreDestinationsList = [
    {'image': 'assets/images/image1.jpg'},
    {'image': 'assets/images/image2.jpg'},
    {'image': 'assets/images/image3.jpg'},
    {'image': 'assets/images/image4.jpg'},
    {'image': 'assets/images/image5.jpg'},
  ];

  final List<Map<String, dynamic>> trendingNowList = [
    {
      'name': 'Tomb of Hazrat Shah Rukn-e-Alam',
      'image': 'assets/images/trending_toba.jpg',
    },
    {
      'name': 'Walled City Ghanta Ghar',
      'image': 'assets/images/trending_bromo.jpg',
    },
    {
      'name': 'Multan Cricket Stadium',
      'image': 'assets/images/trending_raja_ampat.jpg',
    },
    {
      'name': 'Qilla Kohna Qasim Bagh Stadium',
      'image': 'assets/images/trending_bali.jpg',
    },
    {'name': 'Haram Gate', 'image': 'assets/images/trending_komodo.jpg'},
    {
      'name': 'Chaman Zar e Askari Park Multan',
      'image': 'assets/images/trending_borobudur.jpg',
    },
    {'name': 'Multan Arts Council', 'image': 'assets/images/trending_gili.jpg'},
    {'name': 'DHA ZOO', 'image': 'assets/images/trending_toraja.jpg'},
    {
      'name': 'Kashmir Park DHA',
      'image': 'assets/images/trending_wakatobi.jpg',
    },
    {'name': 'Mall of Multan',
     'image': 'assets/images/trending_banda.jpg'},
  ];

  final List<Map<String, dynamic>> journeyTogetherList = [
    {
      'name': 'Kashmir',
      'location': 'North West, Pakistan',
      'image': 'assets/images/kashmir.jpg',
      'rating': '4.7',
      'tags': ['Mountain', 'Hiking'],
      'price': 'Rs 150000',
    },

    {
      'name': 'Lahore',
      'location': 'North East, Pakistan',
      'image': 'assets/images/lahore.jpg',
      'rating': '4.8',
      'tags': ['Architecture', 'Old city'],
      'price': 'Rs 10000',
    },
    {
      'name': 'Skardu',
      'location': 'Northen, Pakistan',
      'image': 'assets/images/skardu.jpg',
      'rating': '4.9',
      'tags': ['Mountains', 'Paragliding'],
      'price': 'Rs 300000',
    },
    {
      'name': 'Babusar Top',
      'location': 'North-East, Pakistan',
      'image': 'assets/images/babusartop.jpg',
      'rating': '4.6',
      'tags': ['Pasu Cones','Surfing'],
      'price': 'Rs 200000',
    },
    {
      'name': 'Fairy Meadows',
      'location': 'Azad Kashmir, Pakistan',
      'image': 'assets/images/fairymeadows.jpg',
      'rating': '4.7',
      'tags': ['Mountain', 'Hiking'],
      'price': 'Rs 15000',
    },
       {
      'name': 'Hunza Valley',
      'location': 'Gilgit-Baltistan, Pakistan',
      'image': 'assets/images/hunza.jpg',
      'rating': '4.7',
      'tags': ['Beach', 'Relaxation'],
      'price': 'Rs 5000',
    },
    {
      'name': 'Peshawar',
      'location': 'Khyber Pakhtunkhwa, Pakistan',
      'image': 'assets/images/peshawar.jpg',
      'rating': '4.8',
      'tags': ['Architecture', 'Culture'],
      'price': 'Rs 18000',
    },
  

    {
      'name': 'Muskhpuri Top',
      'location': 'Nothern Pakistan, Pakistan',
      'image': 'assets/images/mushkpuritop.jpg',
      'rating': '4.9',
      'tags': ['Hiking', 'Mountains'],
      'price': 'Rs 5000',
    },
 
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
                      journeyCards: exploreDestinationsList,
                      pageController: _pageController,
                      currentIndex: _currentIndex,
                      onPageChanged:
                          (index) => setState(() => _currentIndex = index),
                    ),
                    CategoryTabs(
                      tabController: _tabController,
                      categories: _categories,
                    ),
                    TrendingSection(journeyCards: journeyCards),
                    const CategoryIcons(),
                    JourneyTogetherSection(journeyCards: journeyTogetherList),
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

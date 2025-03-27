import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final Widget nextScreen;

  const OnboardingScreen({
    Key? key,
    required this.nextScreen,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _pages = [
    OnboardingItem(
      image: 'assets/images/slashscreen2.jpg', // Replace with your image
      title: 'Life is short and the world is',
      highlightedText: 'wide',
      description: 'So travel, meet, and make new connections. Explore new territory and discover a different side to life.',
      buttonText: 'Next',
      backgroundColor: const Color(0xFFDEF4FE), // Light blue background
    ),
    OnboardingItem(
      image: 'assets/images/splashscreen1.jpg', // Replace with your image
      title: 'It\'s a big world out there go',
      highlightedText: 'explore',
      description: 'So get the best of your adventures and learn about new things for which you\'ve only seen or read in books.',
      buttonText: 'Next',
      backgroundColor: const Color(0xFFF8E5FB), // Light purple background
    ),
    OnboardingItem(
      image: 'assets/images/splashscreen3.jpg', // Replace with your image
      title: 'People don\'t take trips, trips take',
      highlightedText: 'people',
      description: 'To get the best of your adventure you may want to know what others say, see, do or eat in different places in the world.',
      buttonText: 'Get Started',
      backgroundColor: const Color(0xFFDEF4FE), // Light blue background
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          
          // Indicators
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDotIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingItem item) {
    return Container(
      color: item.backgroundColor,
      child: Column(
        children: [
          // Image container
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Text and button container
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with highlighted text
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: item.title + ' '),
                        TextSpan(
                          text: item.highlightedText,
                          style: TextStyle(
                            color: item == _pages[0] 
                                ? Colors.blue 
                                : (item == _pages[1] ? Colors.purple : Colors.green),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Description
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          _navigateToNextScreen();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        item.buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String highlightedText;
  final String description;
  final String buttonText;
  final Color backgroundColor;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.highlightedText,
    required this.description,
    required this.buttonText,
    required this.backgroundColor,
  });
}
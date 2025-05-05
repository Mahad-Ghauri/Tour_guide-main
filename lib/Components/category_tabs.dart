import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';

class CategoryTabs extends StatelessWidget {
  final TabController tabController;
  final List<String> categories;

  const CategoryTabs({
    super.key,
    required this.tabController,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorColor: AppColors.primaryTeal,
          labelColor: AppColors.primaryTeal,
          unselectedLabelColor: AppColors.greyText,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          indicatorSize: TabBarIndicatorSize.label,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_application/Theme/chatbot_theme.dart';
import 'package:tour_guide_application/Screens/review_screen.dart';

class ReviewSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRefresh;

  const ReviewSection({
    super.key,
    required this.reviews,
    required this.isLoading,
    this.errorMessage,
    required this.onRefresh,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "User Reviews",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReviewScreen()),
                  );
                },
                icon: const Icon(Icons.add, size: 16),
                label: Text(
                  "Add Review",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoading)
            _buildReviewSkeletonLoader()
          else if (errorMessage != null)
            Center(
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[300], size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Could not load reviews',
                    style: GoogleFonts.poppins(
                      color: Colors.red[300],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: onRefresh,
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.poppins(color: AppColors.primaryTeal),
                    ),
                  ),
                ],
              ),
            )
          else if (reviews.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    color: AppColors.greyText,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No reviews yet',
                    style: GoogleFonts.poppins(
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ReviewScreen()),
                      );
                    },
                    child: Text(
                      'Be the first to review',
                      style: GoogleFonts.poppins(color: AppColors.primaryTeal),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length > 3 ? 3 : reviews.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(color: Colors.grey.withOpacity(0.2), height: 16),
              itemBuilder: (context, index) {
                final review = reviews[index];
                final username = review['username'] ?? 'Anonymous';
                final comment = review['comment'] ?? 'No comment';
                final rating = (review['rating'] as num?)?.toDouble() ?? 0.0;
                final avatarUrl = review['avatar_url'] as String?;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryTeal.withOpacity(0.1),
                      backgroundImage:
                          avatarUrl != null ? NetworkImage(avatarUrl) : null,
                      child:
                          avatarUrl == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                username,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              _buildRatingStars(rating),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment,
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          if (reviews.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReviewScreen()),
                    );
                  },
                  child: Text(
                    'See All Reviews',
                    style: GoogleFonts.poppins(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 200,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (star) {
        if (star < rating.floor()) {
          return const Icon(Icons.star, color: Colors.amber, size: 14);
        } else if (star < rating) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 14);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 14);
        }
      }),
    );
  }
}

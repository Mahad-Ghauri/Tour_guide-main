import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Controllers/review_controller.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0;

  @override
  void initState() {
    super.initState();
    ReviewController.getReviews(); // Load reviews
  }

  void _submitReview() async {
    final reviewText = _reviewController.text.trim();
    if (reviewText.isEmpty) return;

    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? 'Anonymous';

    await ReviewController.addReview(
      comment: reviewText,
      rating: _rating,
      username: userEmail,
      avatarUrl: 'https://api.dicebear.com/6.x/initials/svg?seed=$userEmail',
    );

    _reviewController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final reviews = ReviewController.reviews;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Reviews"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              itemSize: 30,
              allowHalfRating: true,
              itemCount: 5,
              unratedColor: Colors.grey[300],
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text("Submit Review"),
            ),
            const Divider(height: 30),
            const Text("User Reviews", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(review['avatar_url']),
                    ),
                    title: Text(review['username']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review['comment']),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < review['rating']
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // or push to HomeScreen if needed
              },
              child: const Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }
}

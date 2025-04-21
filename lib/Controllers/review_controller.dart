import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewController {
  static final SupabaseClient _client = Supabase.instance.client;
  static List<Map<String, dynamic>> reviews = [];

  static Future<void> addReview({
    required String username,
    required String comment,
    required double rating,
    required String avatarUrl,
  }) async {
    await _client.from('reviews').insert({
      'username': username,
      'comment': comment,
      'rating': rating,
      'avatar_url': avatarUrl,
    });
    await getReviews(); // refresh the local list
  }

  static Future<void> getReviews() async {
    final response = await _client.from('reviews').select().order('id');
    reviews = List<Map<String, dynamic>>.from(response);
  }
}

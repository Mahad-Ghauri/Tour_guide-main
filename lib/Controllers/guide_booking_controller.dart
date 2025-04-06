import 'package:supabase_flutter/supabase_flutter.dart';

class GuideBookingController {
  final _supabase = Supabase.instance.client;

  Future<void> bookGuide({
    required String guideName,
    required int price,
    required String imageUrl,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = await _supabase.from('booked_guides').insert({
      'user_id': user.id,
      'guide_name': guideName,
      'price': price,
      'image_url': imageUrl,
    });

    if (response.error != null) {
      throw Exception("Failed to book guide: ${response.error!.message}");
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SupabaseService {
  /// Store user's current location in the 'locations' table
  static Future<void> storeLocation(String text, LatLng latLng) async {
    final userId = supabase.Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await supabase.Supabase.instance.client.from('locations').insert({
        'user_id': userId,
        'location_text': text,
        'lat': latLng.latitude,
        'lng': latLng.longitude,
      });
    }
  }
}


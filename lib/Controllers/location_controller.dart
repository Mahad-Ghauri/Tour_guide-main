import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/models/location.dart';

class LocationController {
  final SupabaseClient supabaseClient;

  LocationController({required this.supabaseClient});

  Future<void> saveLocation(Location location) async {
    final response = await supabaseClient.from('locations').insert({
      'name': location.name,
      'latitude': location.latitude,
      'longitude': location.longitude,
    });

    // Check for errors using response.error
    if (response.error != null) {
      throw Exception('Failed to save location: ${response.error!.message}');
    }
  }

  Future<List<Location>> fetchLocations() async {
    final response = await supabaseClient.from('locations').select();

    // Check for errors using response.error
    if (response.error != null) {
      throw Exception('Failed to fetch locations: ${response.error!.message}');
    }

    final List<dynamic> data = response.data;
    return data.map((item) => Location.fromMap(item)).toList();
  }
}

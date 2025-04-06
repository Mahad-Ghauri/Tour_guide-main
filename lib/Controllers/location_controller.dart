import 'package:supabase/supabase.dart'; // Supabase package for database access
import 'package:tour_guide_application/models/location.dart';

class LocationController {
  final SupabaseClient supabaseClient;

  LocationController({required this.supabaseClient});

  Future<void> saveLocation(Location location) async {
    final response =
        await supabaseClient.from('locations').insert({
          'name': location.name,
          'latitude': location.latitude,
          'longitude': location.longitude,
        }).execute();

    if (response.error != null) {
      throw Exception('Failed to save location');
    }
  }

  Future<List<Location>> fetchLocations() async {
    final response = await supabaseClient.from('locations').select().execute();

    if (response.error != null) {
      throw Exception('Failed to fetch locations');
    }

    final List<dynamic> data = response.data;
    return data.map((item) => Location.fromMap(item)).toList();
  }
}

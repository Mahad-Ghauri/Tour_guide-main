import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/models/location_details.dart';

class LocationService {
  /// Save to your Supabase `locations` table if the location doesn't already exist.
  /// Returns true if the operation is successful, false otherwise.
  static Future<bool> save(LocationDetails details) async {
    try {
      // Check if the location already exists by name
      final existingLocations = await Supabase.instance.client
          .from('locations')
          .select('id')
          .eq('name', details.name);

      // If location exists, return false (do not insert)
      if (existingLocations.isNotEmpty) {
        print('Location with this name already exists.');
        return false;
      }

      // Insert the new location if it doesn't exist
      await Supabase.instance.client.from('locations').insert({
        'latitude': details.location.latitude,
        'longitude': details.location.longitude,
        'name': details.name,
        'description': details.description,
      });

      // Success: Insertion completed without throwing an error
      return true;
    } catch (e) {
      // Handle any errors (e.g., network issues, database constraints)
      print('Failed to save location: $e');
      return false;
    }
  }
}
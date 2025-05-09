// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:tour_guide_application/models/location_details.dart';

// class LocationService {
//   /// Save to your Supabase `locations` table if the location doesn't already exist.
//   /// Returns true if the operation is successful, false otherwise.
//   static Future<bool> save(LocationDetails details) async {
//     try {
//       // Check if the location already exists by name
//       final existingLocations = await Supabase.instance.client
//           .from('locations')
//           .select('id')
//           .eq('name', details.name);

//       // If location exists, return false (do not insert)
//       if (existingLocations.isNotEmpty) {
//         print('Location with this name already exists.');
//         return false;
//       }

//       // Insert the new location if it doesn't exist
//       await Supabase.instance.client.from('locations').insert({
//         'latitude': details.location.latitude,
//         'longitude': details.location.longitude,
//         'name': details.name,
//         'description': details.description,
//       });

//       // Success: Insertion completed without throwing an error
//       return true;
//     } catch (e) {
//       // Handle any errors (e.g., network issues, database constraints)
//       print('Failed to save location: $e');
//       return false;
//     }
//   }
// }


import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
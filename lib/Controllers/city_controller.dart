import 'package:supabase_flutter/supabase_flutter.dart';

class CityController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Method to store city in Supabase
  Future<void> storeCityInSupabase(String cityName) async {
    try {
      // Using upsert to add a city if it doesn't exist, or update it if it does
      final response = await _supabase
          .from('cities') // Replace 'cities' with your actual table name
          .upsert([
            {
              'city_name': cityName,
            }, // Assuming the table has a column 'city_name'
          ])
          .eq(
            'city_name',
            cityName,
          ); // Optional: ensure we don't duplicate cities by this column

      // Check if there was an error
      if (response.error == null) {
        print('City inserted or updated successfully');
      } else {
        // Handle the error properly
        throw Exception('Error: ${response.error!.message}');
      }
    } catch (e) {
      // Handle unexpected errors
      print('Error storing city: $e');
    }
  }
}

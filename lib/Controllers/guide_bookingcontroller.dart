import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/Screens/billing_detail_screen.dart';
//import 'package:tour_guide_applicationn/Screens/billing_detail_screen.dart';

class GuideBookingController {
  // Method to handle booking a guide
  Future<void> bookGuide({
    required String guideName,
    required int price,
    required String imageUrl,
    BuildContext? context,
  }) async {
    try {
      // Check if context is provided for navigation
      if (context != null) {
        // Navigate to billing details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BillingDetailsScreen(
                  guideName: guideName,
                  price: price,
                  imageUrl: imageUrl,
                ),
          ),
        );
      }
    } catch (e) {
      // Rethrow any errors
      throw 'Failed to process booking: $e';
    }
  }

  // Method to get all bookings for a user

  Future<List<Map<String, dynamic>>> getUserBooking(String userId) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('booking') // Ensure this matches the actual table name
          .select('*, payments(*)') // Ensure 'payments' is used here
          .eq('user_id', userId) // Filter by user_id
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      throw 'Failed to fetch bookings: $e';
    }
  }

  // Method to cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase
          .from('booking') // Ensure this matches the actual table name
          .update({'status': 'cancelled'})
          .eq('id', bookingId)
          .eq(
            'user_id',
            supabase.auth.currentUser?.id ?? '',
          ); // Add user_id filter
    } catch (e) {
      throw 'Failed to cancel booking: $e';
    }
  }
}

// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  // Ensure the Supabase client is initialized and accessible
  Future<void> initializeSupabase() async {
    try {
      if (Supabase.instance.client == null) {
        // Initialize Supabase only if it's not initialized already
        await Supabase.initialize(
          url:
              'https://wkwhjswjekqlugndxegl.supabase.co', // Replace with your URL
          anonKey:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indrd2hqc3dqZWtxbHVnbmR4ZWdsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI0Nzg3MTQsImV4cCI6MjA1ODA1NDcxNH0.VNb3DAheO5YBx0rtSrk0S9vh13MI3TQlN0VnICQRAJk', // Replace with your anonKey
        );
      }
    } catch (e) {
      print('Error initializing Supabase: $e');
      throw Exception('Failed to initialize Supabase');
    }
  }

  // Get the Supabase client
  SupabaseClient get supabase {
    if (Supabase.instance.client == null) {
      throw Exception('Supabase client is not initialized');
    }
    return Supabase.instance.client;
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:uuid/uuid.dart'; // Add this dependency

class CalendarController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  List<CalendarEvent> _events = [];
  bool _isLoading = false;
  final Uuid _uuid = Uuid(); // For generating unique IDs

  // Getters
  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  List<CalendarEvent> get events => _events;
  bool get isLoading => _isLoading;

  CalendarController() {
    _loadEvents();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void focusDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  Future<void> _loadEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
      final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

      final response = await _supabase
          .from('calendar_events')
          .select()
          .gte('date', startDate.toIso8601String())
          .lte('date', endDate.toIso8601String())
          .order('date', ascending: true);

      _events = response.map((data) => CalendarEvent.fromJson(data)).toList();
        } catch (e) {
      debugPrint('Error loading events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createEvent(String title) async {
    try {
      _isLoading = true;
      notifyListeners();

      final event = CalendarEvent(
        id: _uuid.v4(), // Generate UUID
        title: title,
        date: _selectedDate,
      );

      // Debug the event data before insertion
      debugPrint('Adding event: ${event.toMap()}');
      
      await _supabase.from('calendar_events').insert(event.toMap());
      await _loadEvents();
    } catch (e) {
      debugPrint('Error creating event: $e');
      // Show meaningful error messages
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.from('calendar_events').delete().eq('id', id);
      await _loadEvents();
    } catch (e) {
      debugPrint('Error deleting event: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:tour_guide_application/services/supabase_service.dart';

class CalendarController extends ChangeNotifier {
  final SupabaseClient _supabase = SupabaseService().supabase;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  List<CalendarEvent> _events = [];
  bool _isLoading = false;

  // Getters
  DateTime get selectedDate => _selectedDate;
  DateTime get focusedDate => _focusedDate;
  List<CalendarEvent> get events => _events;
  bool get isLoading => _isLoading;

  CalendarController() {
    _loadEvents();
  }

  // Methods
  void selectDate(DateTime date) {
    _selectedDate = date;
    _loadEvents();
    notifyListeners();
  }

  void focusDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  Future<void> createEvent(CalendarEvent event) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase.from('calendar_events').insert({
        'title': event.title,
        'date': event.date.toIso8601String(),
        'description': event.description,
        'is_festival': event.isFestival ? 1 : 0,
      });

      await _loadEvents();
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEvent(CalendarEvent event) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _supabase
          .from('calendar_events')
          .update(event.toMap())
          .eq('id', event.id);

      await _loadEvents();
    } catch (e) {
      print('Error updating event: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadEvents() async {
    try {
      _isLoading = true;
      notifyListeners();

      final startDate = DateTime(_selectedDate.year, _selectedDate.month, 1);
      final endDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);

      final response = await _supabase
          .from('calendar_events')
          .select()
          .gte('date', startDate.toIso8601String())
          .lt('date', endDate.toIso8601String())
          .order('date', ascending: true);

      _events = response.map((data) => CalendarEvent.fromJson(data)).toList();
    } catch (e) {
      print('Error loading events: $e');
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
      print('Error deleting event: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

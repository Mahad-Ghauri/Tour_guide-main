// lib/screens/calendar_view.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_guide_application/controllers/calendar_controller.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  static const String id = 'CalendarView';
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarController _calendarController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Map<DateTime, List<CalendarEvent>> _events = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _loadMonthEvents(_focusedDay);
  }

  Future<void> _loadMonthEvents(DateTime month) async {
    setState(() => _isLoading = true);
    try {
      final events = await _calendarController.getEventsForMonth(month);
      final newEvents = <DateTime, List<CalendarEvent>>{};
      
      for (final event in events) {
        final day = DateTime(event.date.year, event.date.month, event.date.day);
        newEvents[day] = [...newEvents[day] ?? [], event];
      }

      setState(() {
        _events = newEvents;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading events: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showEventDialog({CalendarEvent? event}) async {
    if (event != null) {
      _titleController.text = event.title;
      _descriptionController.text = event.description;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event == null ? 'Add New Event' : 'Edit Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_selectedDay != null && _titleController.text.isNotEmpty) {
                final newEvent = CalendarEvent(
                  id: event?.id ?? '',
                  title: _titleController.text,
                  date: _selectedDay!,
                  description: _descriptionController.text,
                  isFestival: false,
                );

                try {
                  if (newEvent.id.isEmpty) {
                    await _calendarController.createEvent(newEvent);
                  } else {
                    await _calendarController.updateEvent(newEvent);
                  }
                  await _loadMonthEvents(_focusedDay);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save event: $e')),
                  );
                }
              }
            },
            child: Text(event == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });

              // Display events for the selected day
              final events = _events[selectedDay] ?? [];
              if (events.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Events'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: events.map((event) {
                        return ListTile(
                          title: Text(event.title),
                          subtitle: Text(event.description.isNotEmpty
                              ? event.description
                              : 'No description'),
                        );
                      }).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _loadMonthEvents(focusedDay);
            },
            eventLoader: (day) => _events[day] ?? [],
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _selectedDay != null
                        ? _events[_selectedDay]?.length ?? 0
                        : 0,
                    itemBuilder: (context, index) {
                      final event = _events[_selectedDay]![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date: ${DateFormat.yMMMMd().format(event.date)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (event.description.isNotEmpty)
                                Text(
                                  event.description,
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _showEventDialog(event: event),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  try {
                                    await _calendarController.deleteEvent(event.id);
                                    await _loadMonthEvents(_focusedDay);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to delete event: $e')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

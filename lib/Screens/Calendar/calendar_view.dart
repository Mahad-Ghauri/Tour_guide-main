// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tour_guide_application/controllers/calendar_controller.dart';
import 'package:tour_guide_application/models/calendar_event.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_application/Screens/interface/home_screen.dart';

class CalendarView extends StatelessWidget {
  static const String id = 'CalendarView';
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalendarController(),
      child: const CalendarScreenContent(),
    );
  }
}

class CalendarScreenContent extends StatefulWidget {
  const CalendarScreenContent({super.key});

  @override
  State<CalendarScreenContent> createState() => _CalendarScreenContentState();
}

class _CalendarScreenContentState extends State<CalendarScreenContent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final calendarController = Provider.of<CalendarController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF559CB2),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
      ),
      body:
          calendarController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: calendarController.focusedDate,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(calendarController.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      calendarController.selectDate(selectedDay);
                      calendarController.focusDate(focusedDay);
                    },
                    eventLoader: (day) {
                      return calendarController.events
                          .where((event) => isSameDay(event.date, day))
                          .toList();
                    },
                    onFormatChanged: (format) {
                      setState(() => _calendarFormat = format);
                    },
                    onPageChanged: (focusedDay) {
                      calendarController.focusDate(focusedDay);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF559CB2),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF559CB2),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Selected Date: ${DateFormat.yMMMMd().format(calendarController.selectedDate)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF559CB2),
                      ),
                    ),
                  ),
                  Expanded(child: _buildEventsList(calendarController)),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(context),
        backgroundColor: const Color(0xFF559CB2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventsList(CalendarController calendarController) {
    final events =
        calendarController.events
            .where(
              (event) =>
                  event.date.year == calendarController.selectedDate.year &&
                  event.date.month == calendarController.selectedDate.month &&
                  event.date.day == calendarController.selectedDate.day,
            )
            .toList();

    if (events.isEmpty) {
      return const Center(child: Text('No events for this date'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.title),
          subtitle: Text(DateFormat.Hm().format(event.date)),
          onTap: () => _showEventDialog(context, event),
        );
      },
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    final calendarController = Provider.of<CalendarController>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Add Event'),
            content: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF559CB2), width: 1.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFB3E5FC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFF559CB2), width: 2),
                ),
                filled: true,
                fillColor: Colors.blue[50],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            actions: [
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF559CB2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      calendarController.createEvent(titleController.text);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF559CB2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ),
            ],
          ),
    );
  }

  void _showEventDialog(BuildContext context, CalendarEvent event) {
    final calendarController = Provider.of<CalendarController>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(event.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${DateFormat.yMMMMd().format(event.date)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  calendarController.deleteEvent(event.id);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

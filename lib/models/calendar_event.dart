class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final String description;
  final bool isFestival;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.description = '',
    this.isFestival = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
      'is_festival': isFestival,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String? ?? '',
      isFestival: map['is_festival'] as bool? ?? false,
    );
  }
}
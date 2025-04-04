class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isFestival;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isFestival,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      isFestival: json['is_festival'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'is_festival': isFestival ? 1 : 0,
    };
  }
}

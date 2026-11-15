class Event {
  final int id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String time;
  final String location;
  final String organizer;
  final int capacity;
  final int registered;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.organizer,
    required this.capacity,
    required this.registered,
  });

  int get spotsLeft => capacity - registered;
}

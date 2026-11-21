class Event {
  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

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
  final String imageUrl;

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
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      organizer: json['organizer'] as String,
      capacity: json['capacity'] as int,
      registered: json['registered'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  DateTime get dateTime => DateTime.parse(date);

  String get monthShort => months[dateTime.month - 1];

  String get day => dateTime.day.toString();

  /// Date lisible ("Dec 15, 2026"). Si le format n'est pas AAAA-MM-JJ,
  /// on renvoie le texte tel quel au lieu de planter.
  String get dateLabel {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }

  int get spotsLeft => (capacity - registered).clamp(0, capacity);
}
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event.dart';

class EventService {
  static const String url = 'http://localhost/backend/events.php';

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }
    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event.dart';
import '../models/registration.dart';
import 'api_config.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 5);

  Uri _uri(String file, [Map<String, String>? query]) {
    return Uri.parse(
      '${ApiConfig.baseUrl}/$file',
    ).replace(queryParameters: query);
  }

  Future<List<dynamic>> _getList(String file) async {
    try {
      final response = await http.get(_uri(file)).timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception('Erreur serveur (${response.statusCode})');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      // Sécurité : si PHP renvoie null, on renvoie une liste vide
      return (decoded as List<dynamic>?) ?? [];
    } catch (e) {
      throw Exception('Impossible de contacter le serveur: $e');
    }
  }

  Future<void> _post(String file, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            _uri(file),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);

      if (response.statusCode >= 400) {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi: $e');
    }
  }

  Future<void> _delete(String file, int eventId) async {
    try {
      final response = await http
          .delete(_uri(file, {'eventId': '$eventId'}))
          .timeout(_timeout);

      if (response.statusCode >= 400) {
        throw Exception('Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression: $e');
    }
  }

  Future<List<Event>> fetchEvents() async {
    final data = await _getList('events.php');
    return data
        .map((item) => Event.fromJson(item as Map<String, dynamic>))
        .toList();
  }
    /// POST events.php : renvoie l'événement tel qu'enregistré (avec l'id MySQL).
  Future<Event> addEvent(Event event) async {
    try {
      final response = await http
          .post(
            _uri('events.php'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(event.toJson()),
          )
          .timeout(_timeout);

      if (response.statusCode >= 400) {
        throw Exception('Erreur serveur (${response.statusCode})');
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return Event.fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'événement: $e');
    }
  }

  Future<Set<int>> fetchFavoriteIds() async {
    final data = await _getList('favorites.php');
    // On s'assure de bien convertir en int
    return data.map((id) => (id as num).toInt()).toSet();
  }

  Future<List<Registration>> fetchRegistrations(List<Event> events) async {
    final data = await _getList('registrations.php');
    final result = <Registration>[];

    for (final item in data) {
      final json = item as Map<String, dynamic>;
      final matches = events.where((event) => event.id == json['eventId']);
      if (matches.isNotEmpty) {
        result.add(Registration.fromJson(json, matches.first));
      }
    }
    return result;
  }

  Future<void> addFavorite(int eventId) {
    return _post('favorites.php', {'eventId': eventId});
  }

  Future<void> removeFavorite(int eventId) {
    return _delete('favorites.php', eventId);
  }

  Future<void> addRegistration(Registration registration) {
    return _post('registrations.php', registration.toJson());
  }

  Future<void> removeRegistration(int eventId) {
    return _delete('registrations.php', eventId);
  }
}

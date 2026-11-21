import 'package:flutter/foundation.dart';

import '../data/donnees_fictives.dart' as data;
import '../models/event.dart';
import '../models/registration.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service;
  List<Event> _events = List.of(data.events);
  final Set<int> _favoriteIds = data.favorites.map((e) => e.id).toSet();
  final List<Registration> _registrations = List.of(data.registrations);

  EventProvider({EventService? service}) : _service = service ?? EventService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Event> get events => List.unmodifiable(_events);

  List<Event> get favoriteEvents =>
      _events.where((e) => _favoriteIds.contains(e.id)).toList();

  List<Registration> get registrations => List.unmodifiable(_registrations);

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetched =
          await _service.fetchEvents().timeout(const Duration(seconds: 10));
      if (fetched.isNotEmpty) _events = fetched;
    } catch (_) {
      _errorMessage =
          'Impossible de charger les événements. Données locales affichées.';
    }

    _isLoading = false;
    notifyListeners();
  } 

  
  bool isFavorite(int eventId) => _favoriteIds.contains(eventId);

  void toggleFavorite(int eventId) {
    if (!_favoriteIds.remove(eventId)) {
      _favoriteIds.add(eventId);
    }
    notifyListeners();
  }

  bool isRegistered(int eventId) =>
      _registrations.any((r) => r.event.id == eventId);

  void register(Event event, {String status = 'Confirmed'}) {
    if (isRegistered(event.id)) return;
    _registrations.add(
      Registration(event: event, status: status, registeredOn: _today()),
    );
    notifyListeners();
  }

  void cancelRegistration(int eventId) {
    _registrations.removeWhere((r) => r.event.id == eventId);
    notifyListeners();
  }

  String _today() {
    final now = DateTime.now();
    return '${Event.months[now.month - 1]} ${now.day}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
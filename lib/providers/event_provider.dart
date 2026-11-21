import 'package:flutter/foundation.dart';
import '../data/donnees_fictives.dart' as data;
import '../models/event.dart';
import '../models/registration.dart';
import '../services/api_service.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final EventService _service;
  final ApiService _api;

  List<Event> _events = [];
  final Set<int> _favoriteIds = data.favorites.map((e) => e.id).toSet();
  final List<Registration> _registrations = List.of(data.registrations);

  EventProvider({EventService? service, ApiService? api})
    : _service = service ?? EventService(),
      _api = api ?? ApiService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isOnline = false;
  bool _disposed = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isOnline => _isOnline;

  List<Event> get events => List.unmodifiable(_events);

  List<Event> get favoriteEvents =>
      _events.where((e) => _favoriteIds.contains(e.id)).toList();

  List<Registration> get registrations => List.unmodifiable(_registrations);

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      List<Event> fetched;
      try {
        fetched = await _api.fetchEvents();
        _isOnline = true;
      } catch (_) {
        _isOnline = false;
        fetched = await _service.fetchEvents().timeout(
          const Duration(seconds: 10),
        );
      }
      _events = fetched;
      if (_isOnline) {
        await _loadSavedData();
      }
    } catch (_) {
      _errorMessage =
          'Impossible de charger les événements. Vérifiez votre connexion.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadSavedData() async {
    try {
      final ids = await _api.fetchFavoriteIds();
      final saved = await _api.fetchRegistrations(_events);
      _favoriteIds
        ..clear()
        ..addAll(ids);
      _registrations
        ..clear()
        ..addAll(saved);
    } catch (_) {
      _isOnline = false;
    }
  }

  void _sync(Future<void> Function() action) {
    if (!_isOnline) return;
    action().catchError((_) {
      _isOnline = false;
      notifyListeners();
    });
  }

  bool isFavorite(int eventId) => _favoriteIds.contains(eventId);

  void toggleFavorite(int eventId) {
    final wasFavorite = _favoriteIds.remove(eventId);
    if (!wasFavorite) {
      _favoriteIds.add(eventId);
    }
    notifyListeners();

    _sync(
      () => wasFavorite
          ? _api.removeFavorite(eventId)
          : _api.addFavorite(eventId),
    );
  }

  bool isRegistered(int eventId) =>
      _registrations.any((r) => r.event.id == eventId);

  void register(Event event, {String status = 'Confirmed'}) {
    if (isRegistered(event.id)) return;

    final registration = Registration(
      event: event,
      status: status,
      registeredOn: _today(),
    );
    _registrations.add(registration);
    notifyListeners();
    _sync(() => _api.addRegistration(registration));
  }

  void cancelRegistration(int eventId) {
    _registrations.removeWhere((r) => r.event.id == eventId);
    notifyListeners();
    _sync(() => _api.removeRegistration(eventId));
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

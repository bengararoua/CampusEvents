import 'package:flutter/material.dart';
import '../data/donnees_fictives.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';
import '../services/api_service.dart';
import '../models/event.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ApiService _apiService = ApiService();
  List<Event> _favoriteEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteEvents();
  }

  Future<void> _loadFavoriteEvents() async {
    try {
      final favoriteIds = await _apiService.fetchFavoriteIds();
      setState(() {
        _favoriteEvents = events
            .where((e) => favoriteIds.contains(e.id))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erreur lors du chargement des favoris : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Saved Favorites', style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Quick access to the events you are tracking',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                if (_favoriteEvents.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('Aucun événement en favori pour le moment.'),
                    ),
                  )
                else
                  for (final event in _favoriteEvents)
                    EventCard(
                      event: event,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailsScreen(event: event),
                          ),
                        );
                      },
                    ),
              ],
            ),
    );
  }
}

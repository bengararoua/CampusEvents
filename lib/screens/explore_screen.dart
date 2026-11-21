import 'package:flutter/material.dart';
import '../data/donnees_fictives.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';
import 'formulaire_screen.dart';
import '../services/api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  final Set<int> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final ids = await _apiService.fetchFavoriteIds();
      setState(() {
        _favoriteIds.addAll(ids);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Erreur de chargement: $e');
    }
  }

  Future<void> _toggleFavorite(int eventId) async {
    setState(() {
      if (_favoriteIds.contains(eventId)) {
        _favoriteIds.remove(eventId);
      } else {
        _favoriteIds.add(eventId);
      }
    });

    try {
      if (_favoriteIds.contains(eventId)) {
        await _apiService.addFavorite(eventId);
        print('Ajouté à la BDD : $eventId');
      } else {
        await _apiService.removeFavorite(eventId);
        print('Supprimé de la BDD : $eventId');
      }
    } catch (e) {
      print('Erreur API : $e');
      setState(() {
        if (_favoriteIds.contains(eventId)) {
          _favoriteIds.remove(eventId);
        } else {
          _favoriteIds.add(eventId);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion au serveur')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('All Events', style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  '${events.length} events on campus',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search events',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                for (final event in events)
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
                    isFavorite: _favoriteIds.contains(event.id),
                    onFavoriteToggle: () => _toggleFavorite(event.id),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormulaireScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add event'),
      ),
    );
  }
}

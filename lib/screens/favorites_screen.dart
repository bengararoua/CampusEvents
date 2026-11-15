import 'package:flutter/material.dart';
import '../data/donnees_fictives.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Saved Favorites', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Quick access to the events you are tracking',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          for (final event in favorites)
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

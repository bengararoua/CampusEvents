import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_view.dart';
import 'event_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.events.isEmpty) {
            return const LoadingView(message: 'Chargement des favoris…');
          }

          if (provider.errorMessage != null && provider.events.isEmpty) {
            return ErrorView(
              message: provider.errorMessage!,
              onRetry: provider.loadEvents,
            );
          }
          final favorites = provider.favoriteEvents;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            children: [
              Text(
                'Saved Favorites',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Quick access to the events you are tracking',
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              if (favorites.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      'Aucun favori pour le moment.\nAppuyez sur le cœur d\'un événement pour l\'ajouter.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
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
                    isFavorite: true,
                    onFavoriteToggle: () => provider.toggleFavorite(event.id),
                  ),
            ],
          );
        },
      ),
    );
  }
}

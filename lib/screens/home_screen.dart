import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_view.dart';
import 'event_details_screen.dart';
import 'formulaire_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('CampusEvents')),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.events.isEmpty) {
            return const LoadingView(message: 'Chargement des événements…');
          }

          if (provider.errorMessage != null && provider.events.isEmpty) {
            return ErrorView(
              message: provider.errorMessage!,
              onRetry: provider.loadEvents,
            );
          }

          return RefreshIndicator(
            onRefresh: provider.loadEvents,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Text('Discover Campus Events', style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Find what is happening at your university',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      provider.isOnline ? Icons.cloud_done : Icons.cloud_off,
                      size: 16,
                      color: provider.isOnline
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      provider.isOnline
                          ? 'Connected to the MySQL database'
                          : 'Offline mode: data from the GitHub JSON file',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final event in provider.events)
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
                    isFavorite: provider.isFavorite(event.id),
                    onFavoriteToggle: () => provider.toggleFavorite(event.id),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormulaireScreen()),
          );
        },
        tooltip: 'Créer un événement',
        child: const Icon(Icons.add),
      ),
    );
  }
}

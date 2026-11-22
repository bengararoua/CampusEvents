import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/loading_view.dart';
import 'event_details_screen.dart';
import 'formulaire_screen.dart';
import '../models/event.dart';
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
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

          final events = provider.events;

          return RefreshIndicator(
            onRefresh: provider.loadEvents,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                    isFavorite: provider.isFavorite(event.id),
                    onFavoriteToggle: () => provider.toggleFavorite(event.id),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'explore_fab',
        onPressed: () async {
          final created = await Navigator.push<Event>(
            context,
            MaterialPageRoute(builder: (_) => const FormulaireScreen()),
          );
          if (created != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Événement « ${created.title} » créé')),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add event'),
      ),
    );
  }
}
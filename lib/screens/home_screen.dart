import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/event_featured_card.dart';
import '../widgets/loading_view.dart';
import 'event_details_screen.dart';
import 'formulaire_screen.dart';
import '../models/event.dart';
import '../providers/reglages_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetails(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Consumer<EventProvider>(
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

            final popular = provider.events.take(5).toList();
            final recommended = provider.events.skip(5).toList();

            return RefreshIndicator(
              onRefresh: provider.loadEvents,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          size: 20,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ISET Bizerte, Tunisia',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'CampusEvents',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Changer de thème',
                        icon: Icon(
                          context.watch<ReglagesModel>().sombre
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: () =>
                            context.read<ReglagesModel>().basculerTheme(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Discover Campus Events',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find what is happening at your university',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        provider.isOnline ? Icons.cloud_done : Icons.cloud_off,
                        size: 16,
                        color: provider.isOnline
                            ? colors.primary
                            : colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          provider.isOnline
                              ? 'Connected to the MySQL database'
                              : 'Offline mode: data from the GitHub JSON file',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Popular events',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 250,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: popular.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final event = popular[index];
                        return EventFeaturedCard(
                          event: event,
                          onTap: () => _openDetails(context, event),
                          isFavorite: provider.isFavorite(event.id),
                          onFavoriteToggle: () =>
                              provider.toggleFavorite(event.id),
                        );
                      },
                    ),
                  ),
                  if (recommended.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Recommended',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final event in recommended)
                      EventCard(
                        event: event,
                        onTap: () => _openDetails(context, event),
                        isFavorite: provider.isFavorite(event.id),
                        onFavoriteToggle: () =>
                            provider.toggleFavorite(event.id),
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
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
        tooltip: 'Créer un événement',
        child: const Icon(Icons.add),
      ),
    );
  }
}

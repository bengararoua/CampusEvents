import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../widgets/event_image.dart';
import '../widgets/favorite_button.dart';
import '../widgets/info_pill.dart';
import 'event_registration_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  /// Ouvre le formulaire et récupère son résultat (EF4).
  Future<void> _openRegistration(BuildContext context) async {
    final registered = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EventRegistrationScreen(event: event),
      ),
    );

    if (registered == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscription confirmée pour « ${event.title} »')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isRegistered = context.select<EventProvider, bool>(
      (provider) => provider.isRegistered(event.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [FavoriteButton(event: event)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventImage(url: event.imageUrl),
            const SizedBox(height: 16),
            InfoPill(
              text: event.category,
              background: colors.primary.withValues(alpha: 0.12),
              foreground: colors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Hosted by ${event.organizer}',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(event.dateLabel),
                    subtitle: Text(event.time),
                  ),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(event.location),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Registration capacity',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
              value: event.capacity == 0 ? 0 : event.registered / event.capacity,
            ),
            const SizedBox(height: 8),
            Text(
              '${event.registered} registered • ${event.spotsLeft} spots left of ${event.capacity}',
            ),
            const SizedBox(height: 24),
            Text(
              'About the event',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(event.description),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isRegistered
              ? FilledButton.tonalIcon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Already registered'),
                )
              : FilledButton.icon(
                  onPressed: () => _openRegistration(context),
                  icon: const Icon(Icons.how_to_reg),
                  label: const Text('Register Now'),
                ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/event.dart';
import 'event_registration_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(event.category)),
            const SizedBox(height: 12),
            Text(event.title, style: textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('Hosted by ${event.organizer}', style: textTheme.bodyMedium),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(event.date),
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
            Text('Registration capacity', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: event.registered / event.capacity),
            const SizedBox(height: 8),
            Text(
              '${event.registered} registered • ${event.spotsLeft} spots left of ${event.capacity}',
            ),
            const SizedBox(height: 24),
            Text('About the event', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(event.description),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventRegistrationScreen(event: event),
                ),
              );
            },
            icon: const Icon(Icons.how_to_reg),
            label: const Text('Register Now'),
          ),
        ),
      ),
    );
  }
}

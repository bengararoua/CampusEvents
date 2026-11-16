import 'package:flutter/material.dart';
import '../data/donnees_fictives.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';
import 'formulaire_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: ListView(
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
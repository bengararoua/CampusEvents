import 'package:flutter/material.dart';
import '../data/donnees_fictives.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('CampusEvents')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Discover Campus Events', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Find what is happening at your university',
            style: textTheme.bodyMedium,
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
    );
  }
}

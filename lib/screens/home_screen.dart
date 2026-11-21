import 'package:flutter/material.dart';

import '../data/donnees_fictives.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Events')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Upcoming events',
            style: Theme.of(context).textTheme.headlineSmall,
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

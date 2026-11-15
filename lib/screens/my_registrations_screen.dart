import 'package:flutter/material.dart';
import '../data/donnees_fictives.dart';
import 'event_details_screen.dart';

class MyRegistrationsScreen extends StatelessWidget {
  const MyRegistrationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Registrations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('My Registrations', style: textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Manage your passes and registration status',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          for (final registration in registrations)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.confirmation_number),
                title: Text(registration.event.title),
                subtitle: Text(
                  '${registration.event.date} • ${registration.event.time}\n'
                  'Status: ${registration.status}\n'
                  'Registered on ${registration.registeredOn}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EventDetailsScreen(event: registration.event),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

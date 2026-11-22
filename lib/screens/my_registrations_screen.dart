import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/registration.dart';
import '../providers/event_provider.dart';
import 'event_details_screen.dart';

class MyRegistrationsScreen extends StatelessWidget {
  const MyRegistrationsScreen({super.key});

  Future<void> _confirmCancel(
    BuildContext context,
    Registration registration,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Annuler l\'inscription ?'),
        content: Text(registration.event.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Garder'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Annuler l\'inscription'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<EventProvider>().cancelRegistration(registration.event.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription annulée')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final registrations = context.watch<EventProvider>().registrations;

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
          if (registrations.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: Text('Aucune inscription pour le moment')),
            ),
          for (final registration in registrations)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Image.asset(
                      registration.event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: colors.primaryContainer,
                          child: Icon(
                            Icons.confirmation_number,
                            color: colors.onPrimaryContainer,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  registration.event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${registration.event.dateLabel} • ${registration.event.time}\n'
                  'Status: ${registration.status}\n'
                  'Registered on ${registration.registeredOn}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Annuler l\'inscription',
                  icon: Icon(Icons.cancel_outlined, color: colors.error),
                  onPressed: () => _confirmCancel(context, registration),
                ),
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
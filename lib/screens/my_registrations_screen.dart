import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/registration.dart';
import '../providers/event_provider.dart';
import '../widgets/info_pill.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Text(
            'My Registrations',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your passes and registration status',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EventDetailsScreen(event: registration.event),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: 72,
                          height: 72,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              registration.event.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${registration.event.dateLabel} • ${registration.event.time}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Registered on ${registration.registeredOn}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InfoPill(
                              text: registration.status,
                              icon: Icons.check_circle,
                              background: colors.primary.withValues(alpha: 0.12),
                              foreground: colors.primary,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Annuler l\'inscription',
                        icon: Icon(Icons.cancel_outlined, color: colors.error),
                        onPressed: () => _confirmCancel(context, registration),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
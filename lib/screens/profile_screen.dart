import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: colors.primary,
                child: Icon(Icons.person, size: 48, color: colors.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ben Gara Roua',
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'BenGaraRoua@university.edu',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.school),
                  title: const Text('Département'),
                  subtitle: const Text('Informatique - DSI33'),
                ),
                ListTile(
                  leading: const Icon(Icons.badge),
                  title: const Text('Numéro Étudiant'),
                  subtitle: const Text('STU-2026-1234'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Année universitaire'),
                  subtitle: const Text('2026-2027'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Modifier le profil'),
          ),
        ],
      ),
    );
  }
}
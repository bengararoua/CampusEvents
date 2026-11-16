import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Student Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
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
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const Divider(),
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
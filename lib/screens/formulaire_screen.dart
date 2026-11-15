import 'package:flutter/material.dart';

class FormulaireScreen extends StatelessWidget {
  const FormulaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un événement'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Titre
            const TextField(
              decoration: InputDecoration(
                labelText: 'Titre de l\'événement',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // 2. Catégorie (Menu déroulant)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Hackathons', child: Text('Hackathons')),
                DropdownMenuItem(value: 'Conferences', child: Text('Conférences')),
                DropdownMenuItem(value: 'Workshops', child: Text('Ateliers')),
                DropdownMenuItem(value: 'Clubs', child: Text('Clubs Étudiants')),
              ],
              onChanged: (String? newValue) {
                // Sera utilisé au J2
              },
            ),
            const SizedBox(height: 16),

            // 3. Description
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // 4. Lieu
            const TextField(
              decoration: InputDecoration(
                labelText: 'Lieu',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Nombre de places
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nombre de places',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            
            // 6. Bouton de soumission
            ElevatedButton(
              onPressed: () {
                // Au J1, on affiche juste un message. La sauvegarde viendra au J2.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Formulaire prêt (J1)')),
                );
              },
              child: const Text('Enregistrer l\'événement'),
            ),
          ],
        ),
      ),
    );
  }
}
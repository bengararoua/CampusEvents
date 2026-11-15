import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; 

void main() {
  runApp(const CampusEventsApp());
}

class CampusEventsApp extends StatelessWidget {
  const CampusEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusEvents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Le bleu de votre charte graphique
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      // On lance l'application sur la barre de navigation
      home: const MainScreen(),
    );
  }
}
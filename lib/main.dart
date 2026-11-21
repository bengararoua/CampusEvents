import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    // On enveloppe l'application avec le Provider
    ChangeNotifierProvider(
      create: (_) => EventProvider()..loadEvents(),
      child: const CampusEventsApp(),
    ),
  );
}

class CampusEventsApp extends StatelessWidget {
  const CampusEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusEvents',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

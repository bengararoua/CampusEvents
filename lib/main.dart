import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'providers/reglages_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()..loadEvents()),
        ChangeNotifierProvider(create: (_) => ReglagesModel()..charger()),
      ],
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
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: context.watch<ReglagesModel>().sombre
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const MainScreen(),
    );
  }
}

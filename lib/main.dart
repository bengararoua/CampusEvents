import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; 
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CampusEventsApp());
}

class CampusEventsApp extends StatelessWidget {
  const CampusEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()..loadEvents()),
      ],
      child: MaterialApp(
        title: 'CampusEvents',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
      ),
    );
  }
}
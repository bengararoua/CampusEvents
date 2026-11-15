// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:campusevents/main.dart';

void main() {
  testWidgets('L\'application CampusEvents se lance correctement', (WidgetTester tester) async {
    // 1. On charge l'application (qui appelle CampusEventsApp maintenant)
    await tester.pumpWidget(const CampusEventsApp());

    // 2. On vérifie que l'écran d'accueil s'affiche (le titre dans l'AppBar)
    expect(find.text('CampusEvents'), findsWidgets);

    // 3. On vérifie que la barre de navigation en bas est bien là
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('My Events'), findsOneWidget);
  });
}
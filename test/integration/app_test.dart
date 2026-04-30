// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_diary/main.dart' as app;
import 'package:provider/provider.dart';
import 'package:trip_diary/viewmodels/auth_viewmodel.dart';
import 'package:trip_diary/viewmodels/trip_viewmodel.dart';
import 'package:trip_diary/viewmodels/entry_viewmodel.dart';
import 'package:trip_diary/viewmodels/search_viewmodel.dart';
import 'package:trip_diary/data/repositories/trip_repository.dart';
import 'package:trip_diary/data/repositories/entry_repository.dart';
import 'package:trip_diary/views/screens/trip_form_screen.dart';
import 'package:trip_diary/views/screens/entry_form_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();

  Future<void> launchApp(WidgetTester tester) async {
    await tester.pumpWidget(const app.TripDiaryApp());
    await tester.pumpAndSettle();
  }

  Future<void> launchFreshApp(WidgetTester tester) async {
    await storage.delete(key: 'user_pin');
    await launchApp(tester);
  }

  group('TripDiary Integration Tests', () {
    testWidgets('App launches and displays login screen',
        (WidgetTester tester) async {
      await launchFreshApp(tester);

      expect(find.text('New PIN (4 digits)'), findsOneWidget);
      expect(find.byIcon(Icons.travel_explore), findsOneWidget);
    });

    testWidgets('User can set PIN and login', (WidgetTester tester) async {
      await launchFreshApp(tester);

      await tester.enterText(find.byType(TextField), '1234');
      await tester.pumpAndSettle();
      expect(find.text('Confirm PIN'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '1234');
      await tester.pumpAndSettle();

      expect(find.text('Enter PIN'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '1234');
      await tester.pumpAndSettle();

]      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('Full end-to-end: PIN -> create trip -> add entry -> search',
        (WidgetTester tester) async {
      await launchFreshApp(tester);

      
      await tester.enterText(find.byType(TextField).first, '2468');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '2468');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '2468');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);

      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));
      await tester.pumpAndSettle();

      final tripTitle = 'E2E Trip ${DateTime.now().millisecondsSinceEpoch}';
      final tripDestination = 'Testville';

      await tester.enterText(find.byType(TextField).at(0), tripTitle);
      await tester.enterText(find.byType(TextField).at(1), tripDestination);
      await tester.pumpAndSettle();

      final saveTripButton = find.byKey(const Key('trip_save_button'));
      
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold).last)).removeCurrentSnackBar();
      await tester.pumpAndSettle();
      
      await tester.ensureVisible(saveTripButton);
      await tester.pumpAndSettle();
      
      await tester.tap(saveTripButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text(tripTitle), findsOneWidget);

      await tester.tap(find.text(tripTitle));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));
      await tester.pumpAndSettle();

      final entryTitle = 'E2E Entry ${DateTime.now().millisecondsSinceEpoch}';
      final entryBody = 'This is an automated test entry.';

      await tester.enterText(find.byType(TextField).at(0), entryTitle);
      await tester.enterText(find.byType(TextField).at(1), entryBody);
      await tester.pumpAndSettle();

      final getLocation = find.text('Get Location');
      if (getLocation.evaluate().isNotEmpty) {
        await tester.ensureVisible(getLocation);
        await tester.pumpAndSettle();
        await tester.tap(getLocation);
        await tester.pumpAndSettle(const Duration(seconds: 1));
      }

      final saveButton = find.byKey(const Key('entry_save_button'));
      
      ScaffoldMessenger.of(tester.element(find.byType(Scaffold).last)).removeCurrentSnackBar();
      await tester.pumpAndSettle();
      
      await tester.ensureVisible(saveButton);
      await tester.pumpAndSettle();
      
      await tester.tap(saveButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text(entryTitle), findsWidgets);

     
      await tester.pageBack();
      await tester.pumpAndSettle();

      final searchField = find.byWidgetPredicate((w) {
        return w is TextField && w.decoration?.hintText == 'Search trips...';
      });

      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, tripTitle.substring(0, 6));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text(tripTitle), findsOneWidget);
    });
  });
}

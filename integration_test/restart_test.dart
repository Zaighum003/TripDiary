import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trip_diary/main.dart' as app;

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

  group('App Restart Behavior Tests', () {
    testWidgets('App Restart: Retains PIN and requires login on restart', (WidgetTester tester) async {
      await launchFreshApp(tester);

      // --- PIN setup ---
      await tester.enterText(find.byType(TextField).first, '1234');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '1234');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, '1234');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Home'), findsWidgets);

 
      await launchApp(tester);

      expect(find.text('Enter PIN'), findsOneWidget);
      expect(find.text('New PIN (4 digits)'), findsNothing);

      await tester.enterText(find.byType(TextField).first, '1234');
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Home'), findsWidgets);
    });
  });
}

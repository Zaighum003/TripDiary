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

  group('Navigation Flows Integration Tests', () {
    testWidgets('Navigation flow: Home -> Settings -> Home', (WidgetTester tester) async {
      await launchFreshApp(tester);

      
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

      final settingsIcon = find.byIcon(Icons.settings);
      expect(settingsIcon, findsOneWidget);
      await tester.tap(settingsIcon);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Settings'), findsWidgets);
      
      final homeIcon = find.byIcon(Icons.home);
      expect(homeIcon, findsOneWidget);
      await tester.tap(homeIcon);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Home'), findsWidgets);
    });
  });
}

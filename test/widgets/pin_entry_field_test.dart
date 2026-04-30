// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_diary/views/widgets/pin_entry_field.dart';
import 'package:flutter/material.dart';

void main() {
  group('PinEntryField Widget Tests', () {
    testWidgets('PinEntryField displays correctly', (WidgetTester tester) async {
      String capturedPin = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinEntryField(
              onPinChanged: (pin) {
                capturedPin = pin;
              },
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(PinEntryField), findsOneWidget);
    });

    testWidgets('PinEntryField calls onPinChanged callback',
        (WidgetTester tester) async {
      String capturedPin = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PinEntryField(
              onPinChanged: (pin) {
                capturedPin = pin;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '1234');
      await tester.pumpAndSettle();

      expect(capturedPin, contains('1234'));
    });
  });
}

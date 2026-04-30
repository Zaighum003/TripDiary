import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trip_diary/main.dart';

void main() {
  testWidgets('TripDiary app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const TripDiaryApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

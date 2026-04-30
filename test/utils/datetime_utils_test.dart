// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_diary/core/utils/datetime_utils.dart';

void main() {
  group('DateTimeUtils Tests', () {
    test('formatDate should format date correctly', () {
      final date = DateTime(2024, 6, 15);
      final formatted = DateTimeUtils.formatDate(date);

      expect(formatted, contains('Jun'));
      expect(formatted, contains('15'));
      expect(formatted, contains('2024'));
    });

    test('formatDateRange should format date range', () {
      final startDate = DateTime(2024, 6, 1);
      final endDate = DateTime(2024, 6, 15);
      final formatted = DateTimeUtils.formatDateRange(startDate, endDate);

      expect(formatted, contains('-'));
    });

    test('isSameDay should check if dates are on same day', () {
      final date1 = DateTime(2024, 6, 15, 10, 30);
      final date2 = DateTime(2024, 6, 15, 20, 45);
      final date3 = DateTime(2024, 6, 16, 10, 30);

      expect(DateTimeUtils.isSameDay(date1, date2), true);
      expect(DateTimeUtils.isSameDay(date1, date3), false);
    });

    test('daysBetween should calculate days difference', () {
      final from = DateTime(2024, 6, 1);
      final to = DateTime(2024, 6, 15);

      final days = DateTimeUtils.daysBetween(from, to);

      expect(days, 14);
    });

    test('parseIso8601 should parse ISO date string', () {
      final iso = '2024-06-15T10:30:00.000Z';
      final parsed = DateTimeUtils.parseIso8601(iso);

      expect(parsed.year, 2024);
      expect(parsed.month, 6);
      expect(parsed.day, 15);
    });
  });
}

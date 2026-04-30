// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_diary/data/models/trip_model.dart';

void main() {
  group('Trip Model Tests', () {
    test('Trip.fromMap should create Trip from Map', () {
      final map = {
        'id': 1,
        'title': 'Summer Vacation',
        'destination': 'Paris',
        'start_date': '2024-06-01T00:00:00.000Z',
        'end_date': '2024-06-15T00:00:00.000Z',
        'cover_image_path': '/path/to/image.jpg',
      };

      final trip = Trip.fromMap(map);

      expect(trip.id, 1);
      expect(trip.title, 'Summer Vacation');
      expect(trip.destination, 'Paris');
      expect(trip.coverImagePath, '/path/to/image.jpg');
    });

    test('Trip.toMap should convert Trip to Map', () {
      final trip = Trip(
        id: 1,
        title: 'Summer Vacation',
        destination: 'Paris',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 15),
        coverImagePath: '/path/to/image.jpg',
      );

      final map = trip.toMap();

      expect(map['id'], 1);
      expect(map['title'], 'Summer Vacation');
      expect(map['destination'], 'Paris');
      expect(map['cover_image_path'], '/path/to/image.jpg');
    });

    test('Trip.copyWith should create updated copy', () {
      final trip = Trip(
        id: 1,
        title: 'Summer Vacation',
        destination: 'Paris',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 15),
      );

      final updatedTrip = trip.copyWith(title: 'Winter Vacation');

      expect(updatedTrip.id, 1);
      expect(updatedTrip.title, 'Winter Vacation');
      expect(updatedTrip.destination, 'Paris');
    });
  });
}

// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_diary/data/models/entry_model.dart';

void main() {
  group('Entry Model Tests', () {
    test('Entry.fromMap should create Entry from Map', () {
      final map = {
        'id': 1,
        'trip_id': 1,
        'title': 'Day 1 Adventure',
        'body': 'Had a great time',
        'photo_path': '/path/to/photo.jpg',
        'voice_note_path': null,
        'latitude': 48.8566,
        'longitude': 2.3522,
        'location_name': 'Paris, France',
        'created_at': '2024-06-01T10:00:00.000Z',
      };

      final entry = Entry.fromMap(map);

      expect(entry.id, 1);
      expect(entry.tripId, 1);
      expect(entry.title, 'Day 1 Adventure');
      expect(entry.body, 'Had a great time');
      expect(entry.locationName, 'Paris, France');
    });

    test('Entry.toMap should convert Entry to Map', () {
      final entry = Entry(
        id: 1,
        tripId: 1,
        title: 'Day 1 Adventure',
        body: 'Had a great time',
        photoPath: '/path/to/photo.jpg',
        voiceNotePath: null,
        latitude: 48.8566,
        longitude: 2.3522,
        locationName: 'Paris, France',
        createdAt: DateTime(2024, 6, 1, 10, 0),
      );

      final map = entry.toMap();

      expect(map['id'], 1);
      expect(map['trip_id'], 1);
      expect(map['title'], 'Day 1 Adventure');
      expect(map['location_name'], 'Paris, France');
    });

    test('Entry.copyWith should create updated copy', () {
      final entry = Entry(
        id: 1,
        tripId: 1,
        title: 'Day 1 Adventure',
        body: 'Had a great time',
        createdAt: DateTime(2024, 6, 1),
      );

      final updatedEntry = entry.copyWith(title: 'Day 1 - Amazing Adventure');

      expect(updatedEntry.id, 1);
      expect(updatedEntry.title, 'Day 1 - Amazing Adventure');
      expect(updatedEntry.body, 'Had a great time');
    });
  });
}

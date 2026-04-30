// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

class Entry {
  final int? id;
  final int tripId;
  final String title;
  final String body;
  final String? photoPath;
  final String? voiceNotePath;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final DateTime createdAt;

  Entry({
    this.id,
    required this.tripId,
    required this.title,
    required this.body,
    this.photoPath,
    this.voiceNotePath,
    this.latitude,
    this.longitude,
    this.locationName,
    required this.createdAt,
  });

  // Convert Entry to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'title': title,
      'body': body,
      'photo_path': photoPath,
      'voice_note_path': voiceNotePath,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create Entry from Map (from database)
  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'] as int?,
      tripId: map['trip_id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      photoPath: map['photo_path'] as String?,
      voiceNotePath: map['voice_note_path'] as String?,
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
      locationName: map['location_name'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Copy with method for updates
  Entry copyWith({
    int? id,
    int? tripId,
    String? title,
    String? body,
    String? photoPath,
    String? voiceNotePath,
    double? latitude,
    double? longitude,
    String? locationName,
    DateTime? createdAt,
  }) {
    return Entry(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      body: body ?? this.body,
      photoPath: photoPath ?? this.photoPath,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Entry(id: $id, tripId: $tripId, title: $title, body: $body, photoPath: $photoPath, voiceNotePath: $voiceNotePath, latitude: $latitude, longitude: $longitude, locationName: $locationName, createdAt: $createdAt)';
  }
}

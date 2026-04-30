// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

class Trip {
  final int? id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String? coverImagePath;

  Trip({
    this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.coverImagePath,
  });

  // Convert Trip to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'destination': destination,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'cover_image_path': coverImagePath,
    };
  }

  // Create Trip from Map (from database)
  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'] as int?,
      title: map['title'] as String,
      destination: map['destination'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      coverImagePath: map['cover_image_path'] as String?,
    );
  }

  // Copy with method for updates
  Trip copyWith({
    int? id,
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? coverImagePath,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coverImagePath: coverImagePath ?? this.coverImagePath,
    );
  }

  @override
  String toString() {
    return 'Trip(id: $id, title: $title, destination: $destination, startDate: $startDate, endDate: $endDate, coverImagePath: $coverImagePath)';
  }
}

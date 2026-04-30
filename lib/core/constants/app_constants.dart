// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

class AppConstants {
  // Pin & Auth
  static const int pinLength = 4;
  static const int maxFailedAttempts = 3;
  static const int lockoutDurationSeconds = 300; // 5 minutes

  // Database
  static const String tripTableName = 'trips';
  static const String entryTableName = 'entries';
  static const String userTableName = 'users';

  // File paths
  static const String tripsImageDir = 'trip_covers';
  static const String entryPhotosDir = 'entry_photos';
  static const String voiceNotesDir = 'voice_notes';

  // Voice recording
  static const String audioFileExtension = '.m4a';
  static const int audioQuality = 96;

  // Search
  static const int searchDebounceMs = 300;

  // UI sizing
  static const double touchTargetSize = 48.0;
  static const double cardElevation = 2.0;
  static const double borderRadius = 12.0;

  // Notification
  static const int reminderNotificationId = 100;

  // Reverse geocoding
  static const String reversGeocodeTimeoutSeconds = '10';
}

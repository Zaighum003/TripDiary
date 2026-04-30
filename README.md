# TripDiary - Travel Journalling Mobile Application

A personal travel journalling Flutter mobile application built for the Mobile Applications Development module (55-508210) at Sheffield Hallam University.

## AI Transparency Declaration

**AITS Level 1 - No AI**

All code in this project is 100% student-authored. No AI-generated code has been used in the development of this application.

---

## Project Overview

TripDiary is a feature-rich offline-first mobile application that allows users to:

- **Create and Manage Trips** - Record travel events with titles, destinations, dates, and cover photos
- **Diary Entries** - Document memories with text, photos, voice notes, and GPS locations
- **Media Capture** - Camera photos, audio recording, and GPS tagging
- **Voice Search** - Search trips using voice-to-text functionality
- **Trip Reminders** - Set local notifications for trip departure dates
- **Entry Sharing** - Share diary entries via native share sheet
- **Secure Authentication** - Biometric and PIN-based authentication
- **Offline Storage** - All data persists locally using SQLite

---

## Technical Architecture

### Architectural Pattern: MVVM + Repository

- **View Layer**: Flutter Widgets (Screens & Reusable Components)
- **ViewModel Layer**: ChangeNotifier classes managing app state via Provider
- **Repository Layer**: Data abstraction for clean separation of concerns
- **Data Source**: SQLite database via sqflite package

### Folder Structure

```
lib/
  +-- main.dart                    # App entry point with Provider setup
  +-- core/
  │   +-- constants/               # App colors, strings, constants
  │   +-- theme/                   # Material Design 3 theme
  │   +-- utils/                   # Helper functions (date, file)
  +-- data/
  │   +-- models/                  # Trip, Entry, AppUser models
  │   +-- database/                # DatabaseHelper (SQLite singleton)
  │   +-- repositories/            # TripRepository, EntryRepository
  +-- viewmodels/
  │   +-- auth_viewmodel.dart      # Authentication state
  │   +-- trip_viewmodel.dart      # Trip CRUD management
  │   +-- entry_viewmodel.dart     # Entry CRUD management
  │   +-- search_viewmodel.dart    # Search filtering
  +-- views/
  │   +-- screens/                 # 7 main screens
  │   +-- widgets/                 # 9 reusable UI components
  +-- services/                    # 6 core services
test/
  +-- models/                      # Model unit tests
  +-- utils/                       # Utility function tests
  +-- widgets/                     # Widget tests
integration_test/
  +-- app_test.dart               # End-to-end integration tests
```

---

## Features

### 1. Authentication (SEC)
- ✅ Biometric authentication (Face ID / Touch ID)
- ✅ PIN entry with 4-digit code
- ✅ Fallback to PIN if biometrics unavailable
- ✅ Failed attempt lockout (3 strikes = 5 min lockout)
- ✅ Secure storage using flutter_secure_storage

### 2. Trip Management (TRP)
- ✅ Create trips with title, destination, dates, cover photo
- ✅ Edit existing trips
- ✅ Delete trips with cascade entry deletion
- ✅ View entry count per trip
- ✅ Search trips by title/destination

### 3. Entry Management (ENT)
- ✅ Create entries within trips
- ✅ Add photos via camera or gallery
- ✅ Record voice notes
- ✅ GPS location tagging with reverse geocoding
- ✅ Edit entries
- ✅ Swipe-to-delete gesture
- ✅ Share entries via native share sheet

### 4. Voice Search (SRCH)
- ✅ Microphone icon for voice input
- ✅ Speech-to-text conversion
- ✅ Real-time trip filtering
- ✅ Empty state messaging

### 5. Notifications (NOTIF)
- ✅ Set reminders for trip departure dates
- ✅ Local notifications with flutter_local_notifications
- ✅ Permission handling
- ✅ Tap notification to open trip

### 6. Local Database (DB)
- ✅ SQLite with sqflite package
- ✅ Full CRUD for Trips and Entries
- ✅ Foreign key constraints
- ✅ Cascade deletion
- ✅ Query optimization with indexes

---

## Required Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0                           # Local database
  path_provider: ^2.1.0                     # File system paths
  provider: ^6.1.0                          # State management
  image_picker: ^1.0.0                      # Camera & gallery
  speech_to_text: ^6.3.0                    # Voice search
  just_audio: ^0.9.36                       # Voice playback
  record: ^5.0.4                            # Audio recording
  geolocator: ^11.0.0                       # GPS location
  geocoding: ^2.1.0                         # Reverse geocoding
  flutter_local_notifications: ^17.0.0      # Trip reminders
  timezone: ^0.9.0                          # Notification scheduling
  share_plus: ^7.2.0                        # Native share sheet
  local_auth: ^2.1.6                        # Biometric auth
  flutter_secure_storage: ^9.0.0            # Encrypted storage
  permission_handler: ^11.0.0               # Runtime permissions
  intl: ^0.18.0                             # Date formatting
```

---

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Android SDK (API 23+) or iOS 13+
- Android Studio / VS Code with Flutter extension

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Zaighum003/TripDiary.git
   cd TripDiary
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Environment**
   ```bash
   flutter doctor
   ```

4. **Run the Application**
   ```bash
   # Run on the first available connected device or emulator
   flutter run
   ```

### Verification Steps

To ensure the application is correctly installed and functional:
1. **PIN Setup**: On first launch, you should see the "New PIN" setup screen.
2. **Home Screen**: After setting a PIN, you should arrive at the "Home" screen with an "Add Trip" button.
3. **Persistence**: Create a test trip; it should remain visible even after restarting the application.

---

## Testing Suite

The project includes a comprehensive test suite covering unit, widget, and integration tests.

### 1. Unit & Widget Tests
Verifies business logic, viewmodels, and UI components.
```bash
# Run all unit and widget tests
flutter test
```

### 2. Integration Tests (E2E)
Verifies the full end-to-end application flow (PIN setup -> login -> create trip -> add entry -> search).
**Note:** Ensure an emulator or physical device is running before executing.
```bash
flutter test integration_test/app_test.dart
```

---

## Database Schema

### trips Table
```sql
CREATE TABLE trips (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  destination TEXT NOT NULL,
  start_date TEXT NOT NULL,
  end_date TEXT NOT NULL,
  cover_image_path TEXT
)
```

### entries Table
```sql
CREATE TABLE entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  trip_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  photo_path TEXT,
  voice_note_path TEXT,
  latitude REAL,
  longitude REAL,
  location_name TEXT,
  created_at TEXT NOT NULL,
  FOREIGN KEY(trip_id) REFERENCES trips(id) ON DELETE CASCADE
)
```

---

## State Management Flow

```
User Action (UI Tap)
       ↓
View calls ViewModel Method
       ↓
ViewModel calls Repository Method
       ↓
Repository executes Database Operation
       ↓
Database returns result
       ↓
ViewModel updates state & calls notifyListeners()
       ↓
Consumer widget rebuilds with new state
       ↓
UI reflects changes
```

---

## Screens Overview

| Screen | Purpose | Navigation |
|--------|---------|-----------|
| LoginScreen | Biometric/PIN authentication | App gateway |
| TripsListScreen | View all trips, search, add new | Home tab |
| TripFormScreen | Create/edit trip details | Stack push from home |
| TripDetailScreen | View trip with entry grid | Stack push from trips |
| EntryFormScreen | Create/edit entry with media | Stack push from trip detail |
| EntryDetailScreen | View entry details with tabs | Stack push from trip detail |
| SettingsScreen | PIN change, theme, about | Settings tab |

---

## Platform-Specific Configuration

### Android Permissions (AndroidManifest.xml)
- `android.permission.CAMERA` - Photo capture
- `android.permission.RECORD_AUDIO` - Voice recording
- `android.permission.ACCESS_FINE_LOCATION` - GPS tagging
- `android.permission.POST_NOTIFICATIONS` - Trip reminders
- `android.permission.USE_BIOMETRIC` - Biometric auth

### iOS Permissions (Info.plist)
- NSCameraUsageDescription
- NSMicrophoneUsageDescription
- NSLocationWhenInUseUsageDescription
- NSPhotoLibraryUsageDescription
- NSFaceIDUsageDescription

---

## Testing Strategy

### Unit Tests (60%+ coverage target)
- Trip model serialization
- Entry model serialization
- DateTime utility functions
- ViewModel business logic

### Widget Tests
- PIN entry field display
- Search bar with voice
- Trip card rendering
- Location badge display

### Integration Tests
- User login flow
- Create trip workflow
- Add entry with media
- Voice search filtering

---

## Performance Considerations

- **App Launch**: <3 seconds (mid-range device)
- **Database Queries**: <500ms for 500+ records
- **Voice Recognition**: <1 second activation time
- **Image Optimization**: 85% quality JPEG compression
- **Memory Management**: Proper widget lifecycle cleanup

---

## Non-Functional Requirements

### Usability
- ✅ Material Design 3 compliance
- ✅ Responsive 360dp-600dp width range
- ✅ 48×48dp minimum touch targets
- ✅ Actionable error messages

### Reliability
- ✅ Data persistence on unexpected termination
- ✅ Permission denial handling without crashes
- ✅ Try-catch error handling throughout

### Security
- ✅ PIN encrypted with flutter_secure_storage
- ✅ Biometric sensor integration
- ✅ Local-only data (no network)

### Maintainability
- ✅ SOLID principles followed
- ✅ Widgets ≤250 lines (extraction when needed)
- ✅ Repository pattern for data abstraction
- ✅ Unit test framework established

---

## Code Quality Standards

- **No widget exceeds 250 lines** - Complex widgets are extracted
- **Repository Pattern** - All database logic decoupled from ViewModels
- **SOLID Principles** - Single responsibility, Open/closed, Liskov, Interface segregation, Dependency inversion
- **Error Handling** - All operations wrapped in try-catch with user-visible feedback
- **Permission Requests** - All sensitive operations preceded by permission checks with rationale

---

## Submission Checklist

- ✅ All 9 mobile features implemented (camera, microphone, GPS, notifications, share, voice search, biometric, gestures, local storage)
- ✅ MVVM + Repository architecture (differs from MVP taught in class)
- ✅ Provider state management
- ✅ 100% Dart/Flutter code (no HTML, JS, PHP)
- ✅ SQLite local database (no external APIs)
- ✅ Unit tests with 60%+ coverage
- ✅ Widget and integration tests
- ✅ Platform permissions configured (Android/iOS)
- ✅ Material Design 3 UI
- ✅ No AI tools used in core development

---

## Author

**Student-Authored** - Sheffield Hallam University, Module 55-508210

---

## Version

**1.0.0** - Initial Release (April 2026)

---

## License

This is a university project. All rights reserved.

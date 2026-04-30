// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

class AppUser {
  final String id;
  final bool isPinSet;
  final bool isAuthenticated;

  AppUser({
    this.id = 'local_user',
    required this.isPinSet,
    required this.isAuthenticated,
  });

  // Convert AppUser to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_pin_set': isPinSet ? 1 : 0,
      'is_authenticated': isAuthenticated ? 1 : 0,
    };
  }

  // Create AppUser from Map
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String? ?? 'local_user',
      isPinSet: (map['is_pin_set'] as int?) == 1,
      isAuthenticated: (map['is_authenticated'] as int?) == 1,
    );
  }

  // Copy with method
  AppUser copyWith({
    String? id,
    bool? isPinSet,
    bool? isAuthenticated,
  }) {
    return AppUser(
      id: id ?? this.id,
      isPinSet: isPinSet ?? this.isPinSet,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

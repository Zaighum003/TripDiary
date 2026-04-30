// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/trip_model.dart';
import '../models/entry_model.dart';

class DatabaseHelper {
  static const String _databaseName = 'trip_diary.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tripTableName = 'trips';
  static const String entryTableName = 'entries';

  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Get or initialize database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create trips table
    await db.execute('''
      CREATE TABLE $tripTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        destination TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        cover_image_path TEXT
      )
    ''');

    // Create entries table with foreign key constraint
    await db.execute('''
      CREATE TABLE $entryTableName (
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
        FOREIGN KEY(trip_id) REFERENCES $tripTableName(id) ON DELETE CASCADE
      )
    ''');

    // Create index on trip_id for faster queries
    await db.execute('CREATE INDEX idx_entries_trip_id ON $entryTableName(trip_id)');
  }

  // Close database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }

  // Delete entire database (for testing purposes)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}

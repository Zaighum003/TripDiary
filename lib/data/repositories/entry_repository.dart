// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:sqflite/sqflite.dart';
import '../models/entry_model.dart';
import '../database/database_helper.dart';

class EntryRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  static const String _tableName = 'entries';

  // CREATE - Insert a new entry
  Future<int> insert(Entry entry) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert(
        _tableName,
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print('Error inserting entry: $e');
      rethrow;
    }
  }

  // READ - Get all entries
  Future<List<Entry>> getAll() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        orderBy: 'created_at DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (index) => Entry.fromMap(maps[index]),
      );
    } catch (e) {
      print('Error getting all entries: $e');
      rethrow;
    }
  }

  // READ - Get entries by Trip ID
  Future<List<Entry>> getByTripId(int tripId) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        where: 'trip_id = ?',
        whereArgs: [tripId],
        orderBy: 'created_at DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (index) => Entry.fromMap(maps[index]),
      );
    } catch (e) {
      print('Error getting entries by trip id: $e');
      rethrow;
    }
  }

  // READ - Get entry by ID
  Future<Entry?> getById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Entry.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting entry by id: $e');
      rethrow;
    }
  }

  // UPDATE - Update an existing entry
  Future<int> update(Entry entry) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        _tableName,
        entry.toMap(),
        where: 'id = ?',
        whereArgs: [entry.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      print('Error updating entry: $e');
      rethrow;
    }
  }

  // DELETE - Delete an entry by ID
  Future<int> delete(int id) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return result;
    } catch (e) {
      print('Error deleting entry: $e');
      rethrow;
    }
  }

  // Get count of entries for a specific trip
  Future<int> getCountByTripId(int tripId) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM $_tableName WHERE trip_id = ?',
        [tripId],
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error getting entry count by trip: $e');
      rethrow;
    }
  }

  // Search entries by title or body content
  Future<List<Entry>> search(String query) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        where: 'title LIKE ? OR body LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'created_at DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (index) => Entry.fromMap(maps[index]),
      );
    } catch (e) {
      print('Error searching entries: $e');
      rethrow;
    }
  }
}

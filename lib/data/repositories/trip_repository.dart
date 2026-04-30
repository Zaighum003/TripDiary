// AI Transparency Declaration: AITS Level 1 - No AI Used
// This code is 100% student-authored

import 'package:sqflite/sqflite.dart';
import '../models/trip_model.dart';
import '../database/database_helper.dart';

class TripRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  static const String _tableName = 'trips';

  // CREATE - Insert a new trip
  Future<int> insert(Trip trip) async {
    try {
      final db = await _databaseHelper.database;
      final id = await db.insert(
        _tableName,
        trip.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print('Error inserting trip: $e');
      rethrow;
    }
  }

  // READ - Get all trips
  Future<List<Trip>> getAll() async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        orderBy: 'start_date DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (index) => Trip.fromMap(maps[index]),
      );
    } catch (e) {
      print('Error getting all trips: $e');
      rethrow;
    }
  }

  // READ - Get trip by ID
  Future<Trip?> getById(int id) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Trip.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting trip by id: $e');
      rethrow;
    }
  }

  // UPDATE - Update an existing trip
  Future<int> update(Trip trip) async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.update(
        _tableName,
        trip.toMap(),
        where: 'id = ?',
        whereArgs: [trip.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      print('Error updating trip: $e');
      rethrow;
    }
  }

  // DELETE - Delete a trip (cascade deletes entries due to FK constraint)
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
      print('Error deleting trip: $e');
      rethrow;
    }
  }

  // Get count of all trips
  Future<int> getCount() async {
    try {
      final db = await _databaseHelper.database;
      final result = await db.rawQuery('SELECT COUNT(*) as count FROM $_tableName');
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      print('Error getting trip count: $e');
      rethrow;
    }
  }

  // Search trips by title or destination
  Future<List<Trip>> search(String query) async {
    try {
      final db = await _databaseHelper.database;
      final maps = await db.query(
        _tableName,
        where: 'title LIKE ? OR destination LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'start_date DESC',
      );

      if (maps.isEmpty) {
        return [];
      }

      return List.generate(
        maps.length,
        (index) => Trip.fromMap(maps[index]),
      );
    } catch (e) {
      print('Error searching trips: $e');
      rethrow;
    }
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

class DatabaseHelper {
  static final Logger _log = Logger('DatabaseHelper');

  @visibleForTesting
  static late Database db;
  static bool _isInitialized = false;

  // Singleton pattern to ensure only one instance of the database is used
  static Future<Database> get database async {
    if (!_isInitialized) {
      _log.fine('Database is not initialized. Initializing now.');

      db = await _initDb();
      _isInitialized = true;
    }

    _log.fine('Returning database instance.');

    return db;
  }

  // Initialize the database
  static Future<Database> _initDb() async {
    _log.fine('Initializing the database.');

    final db = sqlite3.open(await _getDbPath());
    _log.fine('Database opened successfully.');

    createDb(db);

    return db;
  }

  // Get the database path
  static Future<String> _getDbPath() async {
    _log.fine('Determining database path.');

    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      _log.fine('Database path for mobile: ${directory.path}/meter_readings.db');

      return '${directory.path}/meter_readings.db';
    } else if (Platform.isWindows) {
      final dir = await Directory.systemTemp.createTemp();

      _log.fine('Database path for Windows: ${dir.path}/meter_readings.db');

      return '${dir.path}/meter_readings.db';
    } else {
      _log.severe('Unsupported platform encountered.');
      throw UnsupportedError("This platform is not supported");
    }
  }

  // Create the table for MeterReadings with a UNIQUE constraint on year, month, day
  @visibleForTesting
  static void createDb(Database db) {
    _log.fine('Creating database table if not exists.');

    db.execute('''
      CREATE TABLE IF NOT EXISTS meter_readings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER NOT NULL,
        month INTEGER NOT NULL,
        day INTEGER NOT NULL,
        reading INTEGER NOT NULL,
        UNIQUE(year, month, day)
      );
    ''');

    _log.fine('Database table created successfully.');
  }

  // Insert a new meter reading into the database with upsert functionality
  static Future<void> insertMeterReading(MeterReading reading) async {
    final db = await database;
    _log.fine('Inserting or updating meter reading: $reading');

    db.execute(
      '''
      INSERT INTO meter_readings (year, month, day, reading)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(year, month, day) DO UPDATE SET
        reading = excluded.reading;
      ''',
      [reading.date.year, reading.date.month, reading.date.day, reading.reading],
    );

    _log.fine('Meter reading inserted/updated successfully.');
  }

  // Fetch all meter readings
  static Future<List<MeterReading>> getMeterReadings() async {
    final db = await database;
    _log.fine('Fetching all meter readings.');

    final result = db.select('SELECT * FROM meter_readings ORDER BY year, month, day');
    _log.fine('Fetched ${result.length} meter readings.');

    return result.map((row) {
      return MeterReading(
        date: DateTime(
          row['year'] as int,
          row['month'] as int,
          row['day'] as int,
          12, // Set the time to 12:00
        ),
        reading: row['reading'] as int,
      );
    }).toList();
  }

  // Fetch a list of distinct years
  static Future<List<int>> getMeterReadingsDistinctYears() async {
    final db = await database;
    _log.fine('Fetching distinct years of meter readings.');

    final result = db.select('SELECT DISTINCT year FROM meter_readings ORDER BY year');
    _log.fine('Fetched ${result.length} distinct years.');

    return result.map((row) => row['year'] as int).toList();
  }

  // Fetch the first reading for a specific year
  static Future<MeterReading?> getMeterReadingForYear(int year) async {
    final db = await database;
    _log.fine('Fetching first meter reading for year $year.');

    final result = db.select(
      '''
    SELECT * FROM meter_readings 
    WHERE year = ? 
    ORDER BY month, day 
    LIMIT 1
    ''',
      [year],
    );
    if (result.isEmpty) {
      _log.fine('No meter reading found for year $year.');

      return null;
    }

    final row = result.first;
    _log.fine('Meter reading for year $year fetched successfully.');

    return MeterReading(
      date: DateTime(
        row['year'],
        row['month'],
        row['day'],
        12, // Set the time to 12:00
      ),
      reading: row['reading'],
    );
  }

  // Fetch the reading for a specific number of days before the current date
  static Future<MeterReading?> getMeterReadingDaysBefore(int daysBefore) async {
    final db = await database;
    final targetDate = DateTime.now().subtract(Duration(days: daysBefore));

    _log.fine('Fetching meter reading for date: $targetDate');
    final result = db.select(
      '''
    SELECT * FROM meter_readings 
    WHERE year = ? AND month = ? AND day = ? 
    LIMIT 1
    ''',
      [targetDate.year, targetDate.month, targetDate.day],
    );
    if (result.isEmpty) {
      _log.fine('No meter reading found for date: $targetDate.');

      return null;
    }

    final row = result.first;
    _log.fine('Meter reading for date $targetDate fetched successfully.');

    return MeterReading(
      date: DateTime(
        row['year'],
        row['month'],
        row['day'],
        12, // Set the time to 12:00
      ),
      reading: row['reading'],
    );
  }

  // Delete all readings
  static Future<void> deleteAllMeterReadings() async {
    final db = await database;

    _log.fine('Deleting all meter readings.');

    db.execute('DELETE FROM meter_readings');
    _log.fine('All meter readings deleted successfully.');
  }
}

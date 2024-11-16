import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

class DatabaseHelper {
  static late Database _db;
  static bool _isInitialized = false;

  // Singleton pattern to ensure only one instance of the database is used
  static Future<Database> get database async {
    if (!_isInitialized) {
      _db = await _initDb();
      _isInitialized = true;
    }
    return _db;
  }

  // Initialize the database
  static Future<Database> _initDb() async {
    final db = sqlite3.open(await _getDbPath());
    _createDb(db);
    return db;
  }

  // Get the database path
  static Future<String> _getDbPath() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // For mobile devices (Android/iOS), use path_provider to get the app's document directory
      final directory = await getApplicationDocumentsDirectory();
      return '${directory.path}/meter_readings.db';
    } else if (Platform.isWindows) {
      // For Windows (testing), use systemTemp directory
      final dir = await Directory.systemTemp.createTemp();
      return '${dir.path}/meter_readings.db';
    } else {
      throw UnsupportedError("This platform is not supported");
    }
  }

  // Create the table for MeterReadings with a UNIQUE constraint on year, month, day
  static void _createDb(Database db) {
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
  }

  // Insert a new meter reading into the database with upsert functionality
  static Future<void> insertMeterReading(MeterReading reading) async {
    final db = await database;
    db.execute(
      '''
      INSERT INTO meter_readings (year, month, day, reading)
      VALUES (?, ?, ?, ?)
      ON CONFLICT(year, month, day) DO UPDATE SET
        reading = excluded.reading;
      ''',
      [reading.date.year, reading.date.month, reading.date.day, reading.reading],
    );
  }

  // Fetch all meter readings
  static Future<List<MeterReading>> getMeterReadings() async {
    final db = await database;
    final result = db.select('SELECT * FROM meter_readings order by year, month, day');
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
  static Future<List<int>> getDistinctYears() async {
    final db = await database;
    final result = db.select('SELECT DISTINCT year FROM meter_readings ORDER BY year');
    return result.map((row) => row['year'] as int).toList();
  }

  // Fetch the first reading for a specific year
  static Future<MeterReading?> getReadingForYear(int year) async {
    final db = await database;
    final result = db.select(
      '''
    SELECT * FROM meter_readings 
    WHERE year = ? 
    ORDER BY month, day 
    LIMIT 1
    ''',
      [year],
    );
    if (result.isEmpty) return null;
    final row = result.first;
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
  static Future<MeterReading?> getReadingDaysBefore(int daysBefore) async {
    final db = await database;
    final targetDate = DateTime.now().subtract(Duration(days: daysBefore));
    final result = db.select(
      '''
    SELECT * FROM meter_readings 
    WHERE year = ? AND month = ? AND day = ? 
    LIMIT 1
    ''',
      [targetDate.year, targetDate.month, targetDate.day],
    );
    if (result.isEmpty) return null;
    final row = result.first;
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
  static Future<void> deleteAllReadings() async {
    final db = await database;
    db.execute('DELETE FROM meter_readings');
  }
}

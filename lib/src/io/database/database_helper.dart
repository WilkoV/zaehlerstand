import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

class DatabaseHelper {
  // Logger for debugging and monitoring database operations.
  static final Logger _log = Logger('DatabaseHelper');

  // The database instance, accessible throughout the app.
  @visibleForTesting
  static late Database db;

  // Tracks whether the database has been initialized.
  static bool _isInitialized = false;

  // Singleton getter for the database instance, ensuring a single instance is used.
  static Future<Database> get database async {
    if (!_isInitialized) {
      _log.fine('Database is not initialized. Initializing now.');

      db = await _initDb();
      _isInitialized = true;
    }

    _log.fine('Returning database instance.');

    return db;
  }

  // Initializes the SQLite database, creating or opening it as needed.
  static Future<Database> _initDb() async {
    _log.fine('Initializing the database.');

    // Open the database using the appropriate file path.
    final db = sqlite3.open(await _getDbPath());
    _log.fine('Database opened successfully.');

    // Ensure the database table exists.
    createDb(db);

    return db;
  }

  // Determines the platform-specific path for storing the database file.
  static Future<String> _getDbPath() async {
    _log.fine('Determining database path.');

    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile platforms: Store in application documents directory.
      final directory = await getApplicationDocumentsDirectory();
      _log.fine('Database path for mobile: ${directory.path}/meter_readings.db');
      return '${directory.path}/meter_readings.db';
    } else if (Platform.isWindows) {
      // Windows: Store in a temporary system directory.
      final dir = await Directory.systemTemp.createTemp();
      _log.fine('Database path for Windows: ${dir.path}/meter_readings.db');
      return '${dir.path}/meter_readings.db';
    } else {
      // Unsupported platform: Log and throw an error.
      _log.severe('Unsupported platform encountered.');
      throw UnsupportedError("This platform is not supported");
    }
  }

  // Creates the database table for storing meter readings if it does not exist.
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
        is_generated INTEGER NOT NULL,
        entered_reading INTEGER NOT NULL,
        is_synced INTEGER NOT NULL,
        UNIQUE(year, month, day) -- Ensures no duplicate entries for the same date
      );
    ''');

    _log.fine('Database table created successfully.');
  }

  // Inserts or updates a meter reading in the database using the `ON CONFLICT` clause.
  static Future<void> insertMeterReading(MeterReading reading) async {
    final db = await database;
    _log.fine('Inserting or updating meter reading: $reading');

    // Convert boolean to integer for storage.
    int generated = reading.isGenerated ? 1 : 0;

    // Perform the SQL insertion or update operation.
    db.execute(
      '''
      INSERT INTO meter_readings (year, month, day, reading, is_generated, entered_reading, is_synced)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(year, month, day) DO UPDATE SET
        reading = excluded.reading, 
        entered_reading = excluded.entered_reading,
        is_generated = excluded.is_generated,
        is_synced = excluded.is_synced;
      ''',
      [reading.date.year, reading.date.month, reading.date.day, reading.reading, generated, reading.enteredReading, reading.isSynced],
    );

    _log.fine('Meter reading inserted/updated successfully.');
  }

  // Fetches all meter readings from the database, sorted by date.
  static Future<List<MeterReading>> getMeterReadings() async {
    final db = await database;
    _log.fine('Fetching all meter readings.');

    // Query all rows from the table and sort by date.
    final result = db.select('SELECT * FROM meter_readings ORDER BY year, month, day');
    _log.fine('Fetched ${result.length} meter readings.');

    // Map the database rows to `MeterReading` objects.
    return result.map((row) {
      return MeterReading(
        date: DateTime(
          row['year'] as int,
          row['month'] as int,
          row['day'] as int,
          12, // Set the time to 12:00 for consistency
        ),
        reading: row['reading'] as int,
        isGenerated: row['is_generated'] as int == 1,
        enteredReading: row['entered_reading'] as int,
        isSynced: row['is_synced'] as int == 1,
      );
    }).toList();
  }

  // Retrieves a list of distinct years from the meter readings.
  static Future<List<int>> getMeterReadingsDistinctYears() async {
    final db = await database;
    _log.fine('Fetching distinct years of meter readings.');

    // Query for distinct years and return them as a list.
    final result = db.select('SELECT DISTINCT year FROM meter_readings ORDER BY year');
    _log.fine('Fetched ${result.length} distinct years.');

    return result.map((row) => row['year'] as int).toList();
  }

  // Fetches the earliest meter reading for a given year.
  static Future<MeterReading?> getMeterReadingForYear(int year) async {
    final db = await database;
    _log.fine('Fetching first meter reading for year $year.');

    // Query for the earliest reading in the specified year.
    final result = db.select(
      '''
    SELECT * FROM meter_readings 
    WHERE year = ? 
    ORDER BY month, day 
    LIMIT 1
    ''',
      [year],
    );

    // Return `null` if no readings were found.
    if (result.isEmpty) {
      _log.fine('No meter reading found for year $year.');
      return null;
    }

    // Map the row to a `MeterReading` object.
    final row = result.first;
    _log.fine('Meter reading for year $year fetched successfully.');

    return MeterReading(
      date: DateTime(
        row['year'] as int,
        row['month'] as int,
        row['day'] as int,
        12,
      ),
      reading: row['reading'] as int,
      isGenerated: row['is_generated'] as int == 1,
      enteredReading: row['entered_reading'] as int,
      isSynced: row['is_synced'] as int == 1,
    );
  }

  // Fetch the reading for a specific number of days before the current date
  static Future<MeterReading?> getMeterReadingDaysBefore(int daysBefore) async {
    final db = await database;

    // Calculate target date
    final targetDate = DateTime.now().subtract(Duration(days: daysBefore));
    _log.fine('Fetching meter reading for date: $targetDate');
    
      // Query for the earliest reading in the calculated day.
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

    // Get row from result set
    final row = result.first;
    _log.fine('Meter reading for date $targetDate fetched successfully.');

    return MeterReading(
      date: DateTime(
        row['year'] as int,
        row['month'] as int,
        row['day'] as int,
        12, // Set the time to 12:00
      ),
      reading: row['reading'] as int,
      isGenerated: row['is_generated'] as int == 1 ? true : false,
      enteredReading: row['entered_reading'] as int,
      isSynced: row['is_synced'] as int == 1 ? true : false,
    );
  }  

  // Deletes all meter readings from the database.
  static Future<void> deleteAllMeterReadings() async {
    final db = await database;
    _log.fine('Deleting all meter readings.');

    // Execute a deletion query.
    db.execute('DELETE FROM meter_readings');
    _log.fine('All meter readings deleted successfully.');
  }

  // Bulk imports multiple meter readings, ensuring atomicity with transactions.
  static Future<void> bulkImport(List<MeterReading> readings) async {
    final db = await database;
    _log.fine('Bulk importing ${readings.length} meter readings.');

    // Begin a transaction to ensure atomicity.
    db.execute('BEGIN TRANSACTION');
    try {
      for (final reading in readings) {
        int generated = reading.isGenerated ? 1 : 0;

        // Insert or update each reading.
        db.execute(
          '''
          INSERT INTO meter_readings (year, month, day, reading, is_generated, entered_reading, is_synced)
          VALUES (?, ?, ?, ?, ?, ?, ?)
          ON CONFLICT(year, month, day) DO UPDATE SET
            reading = excluded.reading, 
            entered_reading = excluded.entered_reading,
            is_generated = excluded.is_generated,
            is_synced = excluded.is_synced;
          ''',
          [reading.date.year, reading.date.month, reading.date.day, reading.reading, generated, reading.enteredReading, reading.isSynced],
        );
      }

      // Commit the transaction if all operations succeed.
      db.execute('COMMIT');
      _log.fine('Bulk import completed successfully.');
    } catch (e) {
      // Roll back the transaction in case of an error.
      db.execute('ROLLBACK');
      _log.severe('Error during bulk import: $e');
      rethrow;
    }
  }

  // Counts the total number of meter readings in the database.
  static Future<int> countMeterReadings() async {
    final db = await database;
    _log.fine('Counting the number of meter readings.');

    // Perform a SQL query to count rows in the table.
    final result = db.select('SELECT COUNT() AS count FROM meter_readings');

    // Extract and return the count.
    final count = result.first['count'] as int;
    _log.fine('Total number of meter readings: $count');

    return count;
  }
}

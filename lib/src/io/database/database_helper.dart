import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';
import 'package:zaehlerstand/src/models/base/weather_info.dart';

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

  // Creates the database table for storing meter readings if it does not exist.
  @visibleForTesting
  static void createDb(Database db) {
    _log.fine('Creating database table if not exists.');

    // Table is de-normalized for performance reasons
    db.execute('''
      CREATE TABLE IF NOT EXISTS readings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER NOT NULL,
        month INTEGER NOT NULL,
        day INTEGER NOT NULL,
        entered_reading INTEGER NOT NULL,
        reading INTEGER NOT NULL,
        is_generated INTEGER NOT NULL,
        is_synced INTEGER NOT NULL,
        weather_year INTEGER NOT NULL,
        weather_month INTEGER NOT NULL,
        weather_day INTEGER NOT NULL,
        temperature REAL NOT NULL,
        weather_is_generated INTEGER NOT NULL,
        UNIQUE(year, month, day) -- Ensures no duplicate entries for the same date
      );
    ''');

    _log.fine('Database table created successfully.');
  }

  // Inserts or updates a meter reading in the database using the `ON CONFLICT` clause.
  static Future<void> insertReading(Reading reading) async {
    final db = await database;
    _log.fine('Inserting or updating meter reading: $reading');

    // Convert boolean to integer for storage.
    int isGenerated = reading.isGenerated ? 1 : 0;
    int isSynced = reading.isSynced ? 1 : 0;
    int weatherIsGenerated = reading.weatherInfo.isGenerated ? 1 : 0;

    // Perform the SQL insertion or update operation.
    db.execute(
      '''
        INSERT INTO readings (year, month, day, entered_reading, reading, is_generated, is_synced, 
        weather_year, weather_month, weather_day, temperature, weather_is_generated)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(year, month, day) DO UPDATE SET
          entered_reading = excluded.entered_reading,
          reading = excluded.reading, 
          is_generated = excluded.is_generated,
          is_synced = excluded.is_synced,
          weather_year = excluded.weather_year,
          weather_month = excluded.weather_month,
          weather_day = excluded.weather_day,
          temperature = excluded.temperature,
          weather_is_generated = excluded.weather_is_generated;          
      ''',
      [
        reading.date.year,
        reading.date.month,
        reading.date.day,
        reading.enteredReading,
        reading.reading,
        isGenerated,
        isSynced,
        reading.weatherInfo.date.year,
        reading.weatherInfo.date.month,
        reading.weatherInfo.date.day,
        reading.weatherInfo.temperature,
        weatherIsGenerated
      ],
    );

    _log.fine('Reading ${reading.toString()} inserted/updated successfully.');
  }

  // Fetches all meter readings from the database, sorted by date.
  static Future<List<Reading>> getAllReadings() async {
    final db = await database;
    _log.fine('Fetching all meter readings.');

    // Query all rows from the table and sort by date.
    final result = db.select('SELECT * FROM readings ORDER BY year DESC, month DESC, day DESC');
    _log.fine('Fetched ${result.length} meter readings.');

    // Map the database rows to `Reading` objects.
    return _createReadingsFromQueryResult(result);
  }

  // Retrieves a list of distinct years from the meter readings.
  static Future<List<int>> getReadingsDistinctYears() async {
    final db = await database;
    _log.fine('Fetching distinct years of meter readings.');

    // Query for distinct years and return them as a list.
    final result = db.select('SELECT DISTINCT year FROM readings ORDER BY year DESC');
    _log.fine('Fetched ${result.length} distinct years.');

    return result.map((row) => row['year'] as int).toList();
  }

  // Fetches the earliest meter reading for a given year.
  static Future<List<Reading>> getReadingForYear(int year) async {
    final db = await database;
    _log.fine('Fetching first meter reading for year $year.');

    // Query for the earliest reading in the specified year.
    final result = db.select(
      'SELECT * FROM readings WHERE year = ?  ORDER BY month DESC, day DESC',
      [year],
    );

    // Map the database rows to `Reading` objects.
    return _createReadingsFromQueryResult(result);
  }

  // Fetches the earliest meter reading for a given year.
  static Future<List<Reading>> getUnsynchronizedReadings() async {
    final db = await database;
    _log.fine('Fetching unsynchronized meter readings.');

    // Query for the earliest reading in the specified year.
    final result = db.select('SELECT * FROM readings WHERE is_synced = 0 ORDER BY year DESC, month DESC, day DESC');

    // Map the database rows to `Reading` objects.
    return _createReadingsFromQueryResult(result);
  }

  // Fetch the reading for a specific number of days before the current date
  static Future<Reading?> getReadingDaysBefore(int daysBefore) async {
    final db = await database;

    // Calculate target date
    final targetDate = DateTime.now().subtract(Duration(days: daysBefore));
    _log.fine('Fetching meter reading for date: $targetDate');

    // Query for the earliest reading in the calculated day.
    final result = db.select(
      'SELECT * FROM readings WHERE year = ? AND month = ? AND day = ? ORDER BY month DESC, day DESC LIMIT 1',
      [targetDate.year, targetDate.month, targetDate.day],
    );
    if (result.isEmpty) {
      _log.fine('No meter reading found for date: $targetDate.');

      return null;
    }

    return _createReadingFromRow(result.first);
  }

  // Deletes all meter readings from the database.
  static Future<void> deleteAllReadings() async {
    final db = await database;
    _log.fine('Deleting all meter readings.');

    // Execute a deletion query.
    db.execute('DELETE FROM readings');
    _log.fine('All meter readings deleted successfully.');
  }

  // Bulk imports multiple meter readings, ensuring atomicity with transactions.
  static Future<void> bulkInsert(List<Reading> readings) async {
    final db = await database;
    _log.fine('Bulk importing ${readings.length} meter readings.');

    // Begin a transaction to ensure atomicity.
    db.execute('BEGIN TRANSACTION');
    try {
      for (final reading in readings) {
        // Convert boolean to integer for storage.
        int isGenerated = reading.isGenerated ? 1 : 0;
        int isSynced = reading.isSynced ? 1 : 0;
        int weatherIsGenerated = reading.weatherInfo.isGenerated ? 1 : 0;

        // Perform the SQL insertion or update operation.
        db.execute(
          '''
            INSERT INTO readings (year, month, day, entered_reading, reading, is_generated, is_synced, 
            weather_year, weather_month, weather_day, temperature, weather_is_generated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(year, month, day) DO UPDATE SET
              entered_reading = excluded.entered_reading,
              reading = excluded.reading, 
              is_generated = excluded.is_generated,
              is_synced = excluded.is_synced,
              weather_year = excluded.weather_year,
              weather_month = excluded.weather_month,
              weather_day = excluded.weather_day,
              temperature = excluded.temperature,
              weather_is_generated = excluded.weather_is_generated;          
          ''',
          [
            reading.date.year,
            reading.date.month,
            reading.date.day,
            reading.enteredReading,
            reading.reading,
            isGenerated,
            isSynced,
            reading.weatherInfo.date.year,
            reading.weatherInfo.date.month,
            reading.weatherInfo.date.day,
            reading.weatherInfo.temperature,
            weatherIsGenerated
          ],
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
  static Future<int> countReadings() async {
    final db = await database;
    _log.fine('Counting the number of meter readings.');

    // Perform a SQL query to count rows in the table.
    final result = db.select('SELECT COUNT() AS count FROM readings');

    // Extract and return the count.
    final count = result.first['count'] as int;
    _log.fine('Total number of meter readings: $count');

    return count;
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
      _log.fine('Database path for mobile: ${directory.path}/readings.db');
      return '${directory.path}/readings.db';
    } else if (Platform.isWindows) {
      // Windows: Store in a temporary system directory.
      final dir = await Directory.systemTemp.createTemp();
      _log.fine('Database path for Windows: ${dir.path}/readings.db');
      return '${dir.path}/readings.db';
    } else {
      // Unsupported platform: Log and throw an error.
      _log.severe('Unsupported platform encountered.');
      throw UnsupportedError("This platform is not supported");
    }
  }

  static List<Reading> _createReadingsFromQueryResult(ResultSet result) {
    _log.fine('Mapping ${result.length} records');
    return result.map((row) {
      return _createReadingFromRow(row);
    }).toList();
  }

  static Reading _createReadingFromRow(Row row) {
    Reading reading = Reading(
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
      weatherInfo: WeatherInfo(
        date: DateTime(
          row['weather_year'] as int,
          row['weather_month'] as int,
          row['weather_day'] as int,
          12, // Set the time to 12:00 for consistency),
        ),
        temperature: row['temperature'] as double,
        isGenerated: row['weather_is_generated'] as int == 1,
      ),
    );

    _log.fine('Reading ${reading.toString()} created');

    return reading;
  }
}

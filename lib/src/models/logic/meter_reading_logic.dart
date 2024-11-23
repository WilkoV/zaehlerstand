import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';

extension MeterReadingLogic on MeterReading {
  static final Logger _log = Logger('MeterReadingLogic');

  /// Converts a [MeterReading] instance into a `List<String>` representation.
  /// Useful for storing or serializing the reading as a row of strings.
  List<String> toStringList() {
    _log.fine('Converting MeterReading to a List<String>');

    // Convert each property of the reading into a string
    List<String> result = [getFormattedDate(), enteredReading.toString(), reading.toString(), isGenerated.toString()];

    _log.fine('Converted MeterReading $result');
    return result;
  }

  /// Converts a [MeterReading] instance into a `List<dynamic>` representation.
  /// Similar to `toStringList` but maintains the type of each value.
  List<dynamic> toDynamicList() {
    _log.fine('Converting MeterReading to a List<dynamic>');

    // Maintain types while converting properties to a list
    List<dynamic> result = [getFormattedDate(), enteredReading, reading, isGenerated];

    _log.fine('Converted MeterReading $result');
    return result;
  }

  /// Creates a [MeterReading] instance from a list of strings.
  /// Assumes the list follows the structure: `[date, reading, isGenerated, enteredReading]`.
  static MeterReading fromStringList(List<String> list) {
    _log.fine('Creating MeterReading from list of Strings: $list');

    // Parse each element from the list to its respective type
    DateTime date = parseDate(list[0]);
    int enteredReading = int.parse(list[1]);
    int reading = int.parse(list[2]);
    bool isGenerated = list[3].toLowerCase() == 'true';

    // Create and return a new MeterReading instance
    MeterReading meterReading = MeterReading(date: date, enteredReading: enteredReading, reading: reading, isGenerated: isGenerated, isSynced: true);

    _log.fine('Created MeterReading = ${meterReading.toString()}');
    return meterReading;
  }

  /// Converts a list of string lists into a list of [MeterReading] instances.
  /// Each sublist represents a row, converted using [fromStringList].
  static List<MeterReading> fromListOfStringLists(List<List<String>> nestedList) {
    List<MeterReading> readings = [];

    for (var row in nestedList) {
      try {
        // Convert each sublist to a MeterReading instance
        readings.add(fromStringList(row));
      } catch (e) {
        _log.warning('Failed to create MeterReading from row: $row', e);
      }
    }

    return readings;
  }

  /// Parses a date string in the format `dd.MM.yyyy` into a [DateTime] object.
  static DateTime parseDate(String dateString) {
    _log.fine('Parsing date: $dateString');

    // Define date format and parse the string
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateTime date = dateFormat.parse(dateString);

    _log.fine('Parsed date is $date');
    return date;
  }

  /// Formats the [date] of the current [MeterReading] instance to `dd.MM.yyyy`.
  String getFormattedDate() {
    _log.fine('Formatting date: ${date.toString()}');

    // Define date format and format the DateTime object
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    String transformedDate = dateFormat.format(date);

    _log.fine('Formatted date: $transformedDate');
    return transformedDate;
  }

  /// Returns the day of the year for the [date] of the current [MeterReading].
  /// E.g., January 1st returns 1, December 31st returns 365/366 (leap years considered).
  int getDayOfYear() {
    _log.fine('Calculating day of the year');

    // Determine the start of the year
    DateTime startOfYear = DateTime(date.year);

    // Calculate the number of days between the start of the year and the current date
    Duration difference = date.difference(startOfYear);
    int dayOfYear = difference.inDays + 1;

    _log.fine('Day of the year is $dayOfYear');
    return dayOfYear;
  }
}

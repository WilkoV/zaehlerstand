import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';

extension ReadingLogic on Reading {
  static final Logger _log = Logger('ReadingLogic');

  /// Converts a [Reading] instance into a `List<String>` representation.
  /// Useful for storing or serializing the reading as a row of strings.
  List<String> toStringList() {
    _log.fine('Converting Reading to a List<String>');

    // Convert each property of the reading into a string
    List<String> result = [getFormattedDate(), enteredReading.toString(), reading.toString(), isGenerated.toString()];

    _log.fine('Converted Reading $result');
    return result;
  }

  /// Converts a [Reading] instance into a `List<dynamic>` representation.
  /// Similar to `toStringList` but maintains the type of each value.
  List<dynamic> toDynamicList() {
    _log.fine('Converting Reading to a List<dynamic>');

    // Maintain types while converting properties to a list
    List<dynamic> result = [getFormattedDate(), enteredReading, reading, isGenerated];

    _log.fine('Converted Reading $result');
    return result;
  }

  /// Creates a [Reading] instance from a list of strings.
  /// Assumes the list follows the structure: `[date, reading, isGenerated, enteredReading]`.
  static Reading fromStringList(List<String> list) {
    _log.fine('Creating Reading from list of Strings: $list');

    // Parse each element from the list to its respective type
    DateTime date = parseDate(list[0]);
    int enteredReading = int.parse(list[1]);
    int reading = int.parse(list[2]);
    bool isGenerated = list[3].toLowerCase() == 'true';

    // Create and return a new Reading instance
    Reading readingFromStringList = Reading(date: date, enteredReading: enteredReading, reading: reading, isGenerated: isGenerated, isSynced: true);

    _log.fine('Created Reading = ${readingFromStringList.toString()}');
    return readingFromStringList;
  }

  /// Converts a list of string lists into a list of [Reading] instances.
  /// Each sublist represents a row, converted using [fromStringList].
  static List<Reading> fromListOfStringLists(List<List<String>> nestedList) {
    List<Reading> readings = [];

    for (var row in nestedList) {
      try {
        // Convert each sublist to a Reading instance
        readings.add(fromStringList(row));
      } catch (e) {
        _log.warning('Failed to create Reading from row: $row', e);
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

  /// Formats the [date] of the current [Reading] instance to `dd.MM.yyyy`.
  String getFormattedDate() {
    _log.fine('Formatting date: ${date.toString()}');

    // Define date format and format the DateTime object
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    String transformedDate = dateFormat.format(date);

    _log.fine('Formatted date: $transformedDate');
    return transformedDate;
  }

  /// Returns the day of the year for the [date] of the current [Reading].
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

  String getFirstTwoDigitsFromReading(int avgDailyConsumption) {
    String readingAsString = (reading + avgDailyConsumption).toString();
    int stringLength = readingAsString.length;

    if (stringLength < 3) {
      return '';
    }

    int targetPosition = stringLength - 3;

    return readingAsString.substring(0, targetPosition);
  }

  static String formatDailyConsumption(int dailyConsumption) {
    return '$dailyConsumption m³';
  }

  static String formattedBool(bool value) {
    return value ? 'Ja' : 'Nein';
  }
  
  String formattedIsGenerated() {
    return formattedBool(isGenerated);
  }

  String formattedIsSynced() {
    return formattedBool(isSynced);
  }
}

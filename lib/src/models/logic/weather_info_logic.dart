import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/models/base/weather_info.dart';

extension WeatherInfoLogic on WeatherInfo {
  static final Logger _log = Logger('WeatherInfoLogic');

  List<String> toStringList() {
    _log.fine('Converting MeterReading to a List<String>');

    // Convert each property of the reading into a string
    List<String> result = [
      getFormattedDate(),
      temperature.toString(),
      isGenerated.toString(),
    ];

    _log.fine('Converted MeterReading $result');
    return result;
  }

  static WeatherInfo fromStringList(List<String> list) {
    _log.fine('Creating MeterReading from list of Strings: $list');

    // Parse each element from the list to its respective type
    DateTime date = parseDate(list[0]);
    double temperature = double.parse(list[1]);
    bool isGenerated = list[3].toLowerCase() == 'true';

    // Create and return a new MeterReading instance
    WeatherInfo weatherInfo = WeatherInfo(date: date, temperature: temperature, isGenerated: isGenerated);

    _log.fine('Created WeatherInfo = ${weatherInfo.toString()}');

    return weatherInfo;
  }

  /// Formats the [date] of the current [MeterReading] instance to `dd.MM.yyyy`.
  String getFormattedDate() {
    String transformedDate = formateDate(date);

    return transformedDate;
  }

  static String formateDate(DateTime date) {
    _log.fine('Formatting date: ${date.toString()}');

    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    String transformedDate = dateFormat.format(date);

    _log.fine('Formatted date: $transformedDate');

    return transformedDate;
  }

  String getFormattedTemperature() {
    String formattedValue = formateDouble(temperature);

    return formattedValue;
  }

  static String formateDouble(double value) {
    var formatter = NumberFormat('0.0', 'de_DE');
    String formattedValue = formatter.format(value);
    return formattedValue;
  }

  /// Parses a date string in the format `dd.MM.yyyy` into a [DateTime] object.
  static DateTime parseDate(String dateString) {
    _log.fine('Parsing date: $dateString');

    // Define date format and parse the string
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateTime date = dateFormat.parse(dateString);

    _log.fine('Parsing date: ${dateString.toString()}');
    _log.fine('Parsed date is $date');
    return date;
  }

  static double? parseStringToDouble(String value) {
    // Check if the value has a decimal point and convert it to the correct format.
    if (value.contains(',')) {
      value = value.replaceAll(',', '.'); // Only replace comma with dot
    }

    try {
      return double.tryParse(value); // Attempt to parse the value as a double.
    } catch (e) {
      _log.warning("Invalid number format: $value");
      return null;
    }
  }
}

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
      feelsLikeTemperature.toString(),
      windSpeed.toString(),
      icon,
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
    double feelsLikeTemperature = double.parse(list[2]);
    double windSpeed = double.parse(list[3]);
    String icon = list[4];
    bool isGenerated = list[3].toLowerCase() == 'true';

    // Create and return a new MeterReading instance
    WeatherInfo weatherInfo = WeatherInfo(date: date, temperature: temperature, feelsLikeTemperature: feelsLikeTemperature, windSpeed: windSpeed, icon: icon, isGenerated: isGenerated);

    _log.fine('Created WeatherInfo = ${weatherInfo.toString()}');

    return weatherInfo;
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

  /// Parses a date string in the format `dd.MM.yyyy` into a [DateTime] object.
  static DateTime parseDate(String dateString) {
    _log.fine('Parsing date: $dateString');

    // Define date format and parse the string
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateTime date = dateFormat.parse(dateString);

    _log.fine('Parsed date is $date');
    return date;
  }
}

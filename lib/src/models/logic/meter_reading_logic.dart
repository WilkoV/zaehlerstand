import 'package:logging/logging.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:intl/intl.dart';

extension MeterReadingLogic on MeterReading {
  static final Logger _log = Logger('MeterReadingLogic');

  List<String> toStringList() {
    _log.fine('Converting MeterReading to a List<String>');

    List<String> result = [
      formatDate(),
      reading.toString(),
      isGenerated.toString(),
      enteredReading.toString(),
    ];

    _log.fine('Converted MeterReading $result');

    return result;
  }

  List<dynamic> toDynamicList() {
    _log.fine('Converting MeterReading to a List<dynamic>');

    List<dynamic> result = [
      formatDate(),
      reading,
      isGenerated,
      enteredReading,
    ];

    _log.fine('Converted MeterReading $result');

    return result;
  }

  static MeterReading fromList(List<String> list) {
    _log.fine('Creating MeterReading from list of Strings: $list');

    DateTime date = parseDate(list[0]);
    int reading = int.parse(list[1]);
    bool isGenerated = list[2].toLowerCase() == 'true';
    int enteredReading = int.parse(list[3]);

    MeterReading meterReading = MeterReading(
      date: date,
      reading: reading,
      isGenerated: isGenerated,
      enteredReading: enteredReading,
      isSynced: true,
    );

    _log.fine('Created MeterReading = ${meterReading.toString()}');

    return meterReading;
  }

  static DateTime parseDate(String dateString) {
    _log.fine('Parse date $dateString');

    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateTime date = dateFormat.parse(dateString);

    _log.fine('Parsed date is $date');
    return date;
  }

  String formatDate() {
    _log.fine('Transforming date ${date.toString()}');

    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    String transformedDate = dateFormat.format(date);

    _log.fine('Transformed date: $transformedDate');

    return transformedDate;
  }

  int getDayOfYear() {
    _log.fine('Get day of the year');
    
    // Get the start of the year
    DateTime startOfYear = DateTime(date.year);

    // Calculate the difference in days
    Duration difference = date.difference(startOfYear);
    int dayOfYear = difference.inDays + 1;

    _log.fine('Day of the year is $dayOfYear');

    return dayOfYear;
  }
}

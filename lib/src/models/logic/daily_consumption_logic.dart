import 'package:zaehlerstand/src/models/base/reading.dart';

extension DailyConsumptionLogic on Reading {
  static String formatDailyConsumption(int dailyConsumption) {
    return '${dailyConsumption.toString().padLeft(6, ' ')} m³';
  }
}

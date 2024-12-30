import 'package:zaehlerstand_common/zaehlerstand_common.dart';

extension DailyConsumptionLogic on Reading {
  static String formatDailyConsumption(int dailyConsumption) {
    return '${dailyConsumption.toString().padLeft(6, ' ')} m³';
  }
}

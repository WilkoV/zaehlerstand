import 'package:zaehlerstand_models/zaehlerstand_models.dart';

extension DailyConsumptionLogic on Reading {
  static String formatDailyConsumption(int dailyConsumption) {
    return '${dailyConsumption.toString().padLeft(6, ' ')} m³';
  }
}

import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/widgets/responsive/meter_reading/meter_reading_responsive_layout.dart';
import 'package:zaehlerstand/src/widgets/data_view/meter_reading_card.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_large.dart';

class MeterReadingListWidget extends StatelessWidget {
  final List<MeterReading> meterReadings;
  final int year;

  const MeterReadingListWidget({
    super.key,
    required this.meterReadings,
    required this.year,
  });

  int calculateDailyConsumption(MeterReading currentReading, int index, List<MeterReading> filteredReadings) {
    int dailyConsumption = 0;

    // Check if the current reading is not the last in the list
    if (index < filteredReadings.length - 1) {
      final nextReading = filteredReadings[index + 1];
      dailyConsumption = currentReading.reading - nextReading.reading;
    } else {
      // For the last reading, find the previous day's reading from the original list
      final previousDate = currentReading.date.subtract(const Duration(days: 1));
      final previousReading = meterReadings.firstWhere(
        (r) => r.date.year == previousDate.year && r.date.month == previousDate.month && r.date.day == previousDate.day,
        orElse: () => currentReading, // Return the current reading if no previous reading is found
      );

      dailyConsumption = currentReading.reading - previousReading.reading;
    }

    return dailyConsumption;
  }

  @override
  Widget build(BuildContext context) {
    // Filter the meter readings by the provided year and reverse the list
    List<MeterReading> filteredReadings = meterReadings.where((reading) => reading.date.year == year).toList(); 

    return SafeArea(
      child: Scaffold(
        body: filteredReadings.isEmpty
            ? const Center(child: TextBodyLarge("Keine Daten gefunden"))
            : ListView.builder(
                itemCount: filteredReadings.length,
                itemBuilder: (context, index) {
                  final reading = filteredReadings[index];
                  // Call the helper method to get the Tagesverbrauch for the current reading
                  int dailyConsumption = calculateDailyConsumption(reading, index, filteredReadings);
      
                  return MeterReadingCardResponsiveLayout(dailyConsumption: dailyConsumption, meterReading: reading);
                },
              ),
      ),
    );
  }
}

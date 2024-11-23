import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';

class MeterReadingListWidget extends StatelessWidget {
  final List<MeterReading> meterReadings;
  final int year;

  const MeterReadingListWidget({
    super.key,
    required this.meterReadings,
    required this.year,
  });

  String calculateDailyConsumption(MeterReading reading, int index, List<MeterReading> filteredReadings) {
    String difference = '';

    // Check if the current reading is not the last in the list
    if (index < filteredReadings.length - 1) {
      final nextReading = filteredReadings[index + 1];
      final diff = reading.reading - nextReading.reading;
      difference = 'Tagesverbrauch: $diff';
    } else {
      // For the last reading, find the previous day's reading from the original list
      final previousDate = reading.date.subtract(const Duration(days: 1));
      final previousReading = meterReadings.firstWhere(
        (r) => r.date.year == previousDate.year && r.date.month == previousDate.month && r.date.day == previousDate.day,
        orElse: () => reading, // Return the current reading if no previous reading is found
      );

      final diff = reading.reading - previousReading.reading;
      difference = 'Tagesverbrauch: $diff';
    }

    return difference;
  }

  @override
  Widget build(BuildContext context) {
    // Filter the meter readings by the provided year and reverse the list
    List<MeterReading> filteredReadings = meterReadings.where((reading) => reading.date.year == year).toList().reversed.toList(); // Reverse the list here

    return Scaffold(
      body: filteredReadings.isEmpty
          ? Center(child: Text("Keine Daten gefunden", style: Theme.of(context).textTheme.bodyLarge))
          : ListView.builder(
              itemCount: filteredReadings.length,
              itemBuilder: (context, index) {
                final reading = filteredReadings[index];
                // Call the helper method to get the Tagesverbrauch for the current reading
                String difference = calculateDailyConsumption(reading, index, filteredReadings);

                return Card(
                  elevation: 4,
                  child: ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(difference, style: Theme.of(context).textTheme.bodyLarge),
                            Text("Datum: ${reading.getFormattedDate()}", style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Zählerstand: ${reading.reading}", style: Theme.of(context).textTheme.bodyMedium),
                            Text("Eingegeben: ${reading.enteredReading}", style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Generiert: ${reading.isGenerated ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              "Gesichert: ${reading.isSynced ? 'Ja' : 'Nein'}",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: reading.isSynced ? null : Colors.red, 
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

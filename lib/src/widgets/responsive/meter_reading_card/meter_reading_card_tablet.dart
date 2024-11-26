import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';

class MeterReadingCardTablet extends StatelessWidget {
  final MeterReading meterReading;
  final DailyConsumption dailyConsumption;

  const MeterReadingCardTablet({
    super.key,
    required this.dailyConsumption,
    required this.meterReading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tagesverbrauch: ${dailyConsumption.value}", style: Theme.of(context).textTheme.bodyLarge),
                Text(meterReading.getFormattedDate(), style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Zählerstand: ${meterReading.reading}", style: Theme.of(context).textTheme.bodyMedium),
                Text("Eingegeben: ${meterReading.enteredReading}", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                meterReading.isSynced
                    ? Text("Gesichert: ${meterReading.isSynced ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium)
                    : Text("Gesichert: ${meterReading.isSynced ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
                Text("Generiert: ${meterReading.isGenerated ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

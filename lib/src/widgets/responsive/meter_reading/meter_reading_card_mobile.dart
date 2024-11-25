import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';

class MeterReadingCardMobile extends StatelessWidget {
  final MeterReading meterReading;
  final DailyConsumption dailyConsumption;

  const MeterReadingCardMobile({
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
            Text("Datum: ${meterReading.getFormattedDate()}", style: Theme.of(context).textTheme.bodyLarge),
            Text("Tagesverbrauch: ${dailyConsumption.value}", style: Theme.of(context).textTheme.bodyLarge),
            Text("Zählerstand: ${meterReading.reading}", style: Theme.of(context).textTheme.bodyMedium),
            Text("Eingegeben: ${meterReading.enteredReading}", style: Theme.of(context).textTheme.bodyMedium),
            Text("Generiert: ${meterReading.isGenerated ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium),
            meterReading.isSynced ? Text("Gesichert: Ja", style: Theme.of(context).textTheme.bodyMedium) : Text("Gesichert: Nein", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';
import 'package:zaehlerstand/src/models/logic/reading_logic.dart';

class ReadingCard extends StatelessWidget {
  final Reading reading;
  final DailyConsumption dailyConsumption;

  const ReadingCard({
    super.key,
    required this.dailyConsumption,
    required this.reading,
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
                Text("Tagesverbrauch: ${ReadingLogic.formatDailyConsumption(dailyConsumption.value)}", style: Theme.of(context).textTheme.bodyLarge),
                Text(reading.getFormattedDate(), style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Zählerstand: ${reading.reading}", style: Theme.of(context).textTheme.bodyMedium),
                reading.isSynced
                    ? Text('Gesichert: ${reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium)
                    : Text('Gesichert: ${reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Generiert: ${reading.formattedIsGenerated()}", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

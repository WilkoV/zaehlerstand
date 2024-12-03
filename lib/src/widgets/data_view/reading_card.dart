import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';
import 'package:zaehlerstand/src/models/logic/reading_logic.dart';

class ReadingCard extends StatelessWidget {
  const ReadingCard({
    super.key,
    required this.dailyConsumption,
    required this.reading,
  });

  final int dailyConsumption;
  final Reading reading;

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
                Text("Tagesverbrauch: $dailyConsumption", style: Theme.of(context).textTheme.bodyLarge),
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
                reading.isSynced
                    ? Text("Gesichert: ${reading.isSynced ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium)
                    : Text("Gesichert: ${reading.isSynced ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

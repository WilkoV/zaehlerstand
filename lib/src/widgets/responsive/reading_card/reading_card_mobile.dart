import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';
import 'package:zaehlerstand/src/models/logic/reading_logic.dart';

class ReadingCardMobile extends StatelessWidget {
  final Reading reading;
  final DailyConsumption dailyConsumption;

  const ReadingCardMobile({
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
            Text("Datum: ${reading.getFormattedDate()}", style: Theme.of(context).textTheme.bodyLarge),
            Text("Tagesverbrauch: ${dailyConsumption.value}", style: Theme.of(context).textTheme.bodyLarge),
            Text("Zählerstand: ${reading.reading}", style: Theme.of(context).textTheme.bodyMedium),
            Text("Eingegeben: ${reading.enteredReading}", style: Theme.of(context).textTheme.bodyMedium),
            Text("Generiert: ${reading.isGenerated ? 'Ja' : 'Nein'}", style: Theme.of(context).textTheme.bodyMedium),
            reading.isSynced ? Text("Gesichert: Ja", style: Theme.of(context).textTheme.bodyMedium) : Text("Gesichert: Nein", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class ReadingCardNarrow extends StatelessWidget {
  final Reading reading;
  final DailyConsumption dailyConsumption;

  const ReadingCardNarrow({
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
            Text('Tagesverbrauch: ${ReadingLogic.formatDailyConsumption(dailyConsumption.consumption)}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Datum: ${reading.getFormattedDate()}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Zählerstand: ${reading.reading}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Generiert: ${reading.isGenerated ? 'Ja' : 'Nein'}', style: Theme.of(context).textTheme.bodyMedium),
            reading.isSynced
                ? Text('Gesichert: ${reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium)
                : Text('Gesichert: ${reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

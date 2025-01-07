import 'package:flutter/material.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class ReadingCardNarrow extends StatelessWidget {
  final ReadingDetail readingDetail;

  const ReadingCardNarrow({
    super.key,
    required this.readingDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (readingDetail.consumption != null) Text('Tagesverbrauch: ${ReadingLogic.formatDailyConsumption(readingDetail.consumption!.consumption)}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Datum: ${readingDetail.reading.getFormattedDate()}', style: Theme.of(context).textTheme.bodyLarge),
            if (readingDetail.weatherInfo != null) Text('Min. Temperatur: ${readingDetail.weatherInfo!.minTemperature}', style: Theme.of(context).textTheme.bodyMedium),
            if (readingDetail.weatherInfo != null) Text('Max. Temperatur: ${readingDetail.weatherInfo!.maxTemperature}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Zählerstand: ${readingDetail.reading.reading}', style: Theme.of(context).textTheme.bodyMedium),
            Text('Generiert: ${readingDetail.reading.isGenerated ? 'Ja' : 'Nein'}', style: Theme.of(context).textTheme.bodyMedium),
            readingDetail.reading.isSynced
                ? Text('Gesichert: ${readingDetail.reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium)
                : Text('Gesichert: ${readingDetail.reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}

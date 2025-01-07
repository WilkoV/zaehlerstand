import 'package:flutter/material.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class ReadingCardWide extends StatelessWidget {
  final ReadingDetail readingDetail;

  const ReadingCardWide({
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (readingDetail.consumption != null) Text('Tagesverbrauch: ${ReadingLogic.formatDailyConsumption(readingDetail.consumption!.consumption)}', style: Theme.of(context).textTheme.bodyLarge),
                Text(readingDetail.reading.getFormattedDate(), style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            if (readingDetail.weatherInfo != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Min. Temperatur: ${readingDetail.weatherInfo!.minTemperature}', style: Theme.of(context).textTheme.bodyMedium),
                  Text('Max. Temperatur: ${readingDetail.weatherInfo!.maxTemperature}', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Zählerstand: ${readingDetail.reading.reading}', style: Theme.of(context).textTheme.bodyMedium),
                readingDetail.reading.isSynced
                    ? Text('Gesichert: ${readingDetail.reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium)
                    : Text('Gesichert: ${readingDetail.reading.formattedIsSynced()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Generiert: ${readingDetail.reading.formattedIsGenerated()}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

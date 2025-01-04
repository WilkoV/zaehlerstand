import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/logic/daily_consumption_logic.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_arrow.dart';

class ReadingConsumptionElement extends StatelessWidget {
  final int? consumption;
  final int? compareConsumptionWith;
  final double? minTemperature;
  final double? maxTemperature;
  final double? minFeelsLike;
  final double? maxFeelsLike;
  final String? label;

  const ReadingConsumptionElement({
    super.key,
    this.consumption,
    this.compareConsumptionWith,
    this.minTemperature,
    this.maxTemperature,
    this.minFeelsLike,
    this.maxFeelsLike,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            consumption != null
                ? Text(
                    DailyConsumptionLogic.formatDailyConsumption(consumption!),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : Text(
                    'K/A',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            ReadingConsumptionArrow(
              consumption: consumption,
              compareConsumptionWith: compareConsumptionWith,
            ),
          ],
        ),
        minTemperature != null && maxTemperature != null
            ? Text(
                '${minTemperature!.toStringAsFixed(1)}°C - ${maxTemperature!.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              )
            : Text(
                'K/A',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
        const SizedBox(height: 8.0),
        if (label != null)
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        else
          Text(
            '',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  String getDayMonth(DateTime? date) {
    if (date == null) {
      return '--.--';
    }
    return '${date.day}.${date.month}';
  }

  String getYear(DateTime? date) {
    if (date == null) {
      return '--.--';
    }
    return '${date.year}';
  }
}

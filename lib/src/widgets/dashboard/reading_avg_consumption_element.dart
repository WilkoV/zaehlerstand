import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/dashboard/reading_avg_consumption_arrowy.dart';

class ReadingAvgConsumptionElement extends StatelessWidget {
  final String? label;
  final double? consumption;
  final double? compareConsumptionWith;
  final int? reading;
  final int? minReading;
  final int? maxReading;
  final double? minTemperature;
  final double? maxTemperature;
  final double? minFeelsLike;
  final double? maxFeelsLike;

  const ReadingAvgConsumptionElement({
    super.key,
    this.label,
    this.consumption,
    this.compareConsumptionWith,
    this.reading,
    this.minReading,
    this.maxReading,
    this.minTemperature,
    this.maxTemperature,
    this.minFeelsLike,
    this.maxFeelsLike,
  });

  @override
  Widget build(BuildContext context) {
    if (consumption == null) {
      return Center(
        child: Text(
          '--',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                consumption != null
                    ? Text(
                        '${consumption!.toStringAsFixed(1).padLeft(6)}m³',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : Text(
                        "--".padLeft(6),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                ReadingAvgConsumptionArrow(
                  consumption: consumption,
                  compareConsumptionWith: compareConsumptionWith,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            if (settingsProvider.showReading && reading != null)
              Text(
                '${reading.toString().padLeft(6)}m³',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (settingsProvider.showReading && minReading != null && maxReading != null)
              Text(
                '${minReading.toString().padLeft(6)} - ${maxReading.toString().padLeft(6)}m³',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (settingsProvider.showTemperature && minTemperature != null && maxTemperature != null)
              Text(
                '${minTemperature!.toStringAsFixed(1)} - ${maxTemperature!.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            if (settingsProvider.showFeelsLike && minFeelsLike != null && maxFeelsLike != null)
              Text(
                '${minFeelsLike!.toStringAsFixed(1)} - ${maxFeelsLike!.toStringAsFixed(1)}°C',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
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
      },
    );
  }

  String getDayMonth(DateTime? date) {
    if (date == null) {
      return "--.--";
    }
    return "${date.day}.${date.month}";
  }

  String getYear(DateTime? date) {
    if (date == null) {
      return "--.--";
    }
    return "${date.year}";
  }
}

import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';

class DashboardReadingBaseElement extends StatelessWidget {
  final String? label;
  final int? reading;
  final int? minReading;
  final int? maxReading;
  final double? minTemperature;
  final double? maxTemperature;
  final double? minFeelsLike;
  final double? maxFeelsLike;

  const DashboardReadingBaseElement({
    super.key,
    this.label,
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
    throw UnimplementedError('BaseReadingElement is an abstract class. Override build in subclasses.');
  }

  List<Widget> buildSecondaryElements(BuildContext context, SettingsProvider settingsProvider) {
    return [
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
          '${minTemperature!.toStringAsFixed(1)} - ${maxTemperature!.toStringAsFixed(1)}°',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      if (settingsProvider.showFeelsLike && minFeelsLike != null && maxFeelsLike != null)
        Text(
          '${minFeelsLike!.toStringAsFixed(1)} - ${maxFeelsLike!.toStringAsFixed(1)}°',
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
    ];
  }
}

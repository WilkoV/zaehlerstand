import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/dashboard/base_reading_element.dart';
import 'package:zaehlerstand/src/widgets/dashboard/reading_avg_consumption_arrowy.dart';

class ReadingAvgConsumptionElement extends BaseReadingElement {
  final double? consumption;
  final double? compareConsumptionWith;

  const ReadingAvgConsumptionElement({
    super.key,
    super.label,
    this.consumption,
    this.compareConsumptionWith,
    super.reading,
    super.minReading,
    super.maxReading,
    super.minTemperature,
    super.maxTemperature,
    super.minFeelsLike,
    super.maxFeelsLike,
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
            _buildConsumptionElement(context),
            ...buildSecondaryElements(context, settingsProvider),
          ],
        );
      },
    );
  }

  Row _buildConsumptionElement(BuildContext context) {
    return Row(
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

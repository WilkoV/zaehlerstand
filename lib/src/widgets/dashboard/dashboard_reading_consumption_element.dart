import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/models/logic/daily_consumption_logic.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_reading_base_element.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_reading_consumption_arrow.dart';

class DashboardReadingConsumptionElement extends DashboardReadingBaseElement {
  final int? consumption;
  final int? compareConsumptionWith;

  const DashboardReadingConsumptionElement({
    super.key,
    required super.isTablet,
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
            if (settingsProvider.showConsumption) _buildConsumptionElement(context),
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
                DailyConsumptionLogic.formatDailyConsumption(consumption!),
                style: Theme.of(context).textTheme.bodyLarge,
              )
            : Text(
                "--".padLeft(6),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
        DashboardReadingConsumptionArrow(
          isTablet: isTablet,
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

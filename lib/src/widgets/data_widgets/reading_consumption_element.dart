import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/logic/daily_consumption_logic.dart';
import 'package:zaehlerstand/src/models/logic/reading_logic.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_arrow.dart';

class ReadingConsumptionElement extends StatelessWidget {
  final int? consumption;
  final DateTime? consumptionDate;
  final int? compareConsumptionWith;
  final String? label;

  const ReadingConsumptionElement({
    super.key,
    this.consumption,
    this.consumptionDate,
    this.compareConsumptionWith,
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
                    "--".padLeft(6),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
            ReadingConsumptionArrow(
              consumption: consumption,
              compareConsumptionWith: compareConsumptionWith,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        if (consumptionDate != null)
          Text(
            ReadingLogic.formatDate(consumptionDate!),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        else if (label != null)
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

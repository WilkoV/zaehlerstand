import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_large.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium_red.dart';

class MeterReadingCardTablet extends StatelessWidget {
  const MeterReadingCardTablet({
    super.key,
    required this.dailyConsumption,
    required this.meterReading,
  });

  final int dailyConsumption;
  final MeterReading meterReading;

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
                TextBodyLarge("Tagesverbrauch: $dailyConsumption"),
                TextBodyLarge("Datum: ${meterReading.getFormattedDate()}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBodyMedium("Zählerstand: ${meterReading.reading}"),
                TextBodyMedium("Eingegeben: ${meterReading.enteredReading}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBodyMedium("Generiert: ${meterReading.isGenerated ? 'Ja' : 'Nein'}"),
                meterReading.isSynced ? TextBodyMedium("Gesichert: ${meterReading.isSynced ? 'Ja' : 'Nein'}") : TextBodyMediumRed("Gesichert: ${meterReading.isSynced ? 'Ja' : 'Nein'}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

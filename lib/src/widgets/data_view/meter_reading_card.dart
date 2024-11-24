import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_large.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium_red.dart';

class MeterReadingCard extends StatelessWidget {
  const MeterReadingCard({
    super.key,
    required this.dailyConsumption,
    required this.reading,
  });

  final int dailyConsumption;
  final MeterReading reading;

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
                TextBodyLarge("Datum: ${reading.getFormattedDate()}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBodyMedium("Zählerstand: ${reading.reading}"),
                TextBodyMedium("Eingegeben: ${reading.enteredReading}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBodyMedium("Generiert: ${reading.isGenerated ? 'Ja' : 'Nein'}"),
                reading.isSynced ? TextBodyMedium("Gesichert: ${reading.isSynced ? 'Ja' : 'Nein'}") : TextBodyMediumRed("Gesichert: ${reading.isSynced ? 'Ja' : 'Nein'}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

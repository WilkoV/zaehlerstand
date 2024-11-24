import 'package:flutter/material.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/models/logic/meter_reading_logic.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_large.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium.dart';
import 'package:zaehlerstand/src/widgets/text/text_body_medium_red.dart';

class MeterReadingCardMobile extends StatelessWidget {
  const MeterReadingCardMobile({
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
            TextBodyLarge("Datum: ${meterReading.getFormattedDate()}"),
            TextBodyLarge("Tagesverbrauch: $dailyConsumption"),
            TextBodyMedium("Zählerstand: ${meterReading.reading}"),
            TextBodyMedium("Eingegeben: ${meterReading.enteredReading}"),
            TextBodyMedium("Generiert: ${meterReading.isGenerated ? 'Ja' : 'Nein'}"),
            meterReading.isSynced ? const TextBodyMedium("Gesichert: Ja") : const TextBodyMediumRed("Gesichert: Nein"),
          ],
        ),
      ),
    );
  }
}

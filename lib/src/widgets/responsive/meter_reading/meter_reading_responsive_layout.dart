import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/meter_reading.dart';
import 'package:zaehlerstand/src/widgets/responsive/meter_reading/meter_reading_card_mobile.dart';
import 'package:zaehlerstand/src/widgets/responsive/meter_reading/meter_reading_card_tablet.dart';

class MeterReadingCardResponsiveLayout extends StatelessWidget {
  final MeterReading meterReading;
  final DailyConsumption dailyConsumption;

  const MeterReadingCardResponsiveLayout({
    super.key,
    required this.meterReading,
    required this.dailyConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => MeterReadingCardMobile(meterReading: meterReading, dailyConsumption: dailyConsumption,),
      tablet: (_) => MeterReadingCardTablet(meterReading: meterReading, dailyConsumption: dailyConsumption,),
    );
  }
}

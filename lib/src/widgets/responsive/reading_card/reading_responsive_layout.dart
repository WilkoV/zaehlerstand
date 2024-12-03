import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/models/base/reading.dart';
import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_mobile.dart';
import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_tablet.dart';

class ReadingCardResponsiveLayout extends StatelessWidget {
  final Reading reading;
  final DailyConsumption dailyConsumption;

  const ReadingCardResponsiveLayout({
    super.key,
    required this.reading,
    required this.dailyConsumption,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => ReadingCardMobile(reading: reading, dailyConsumption: dailyConsumption,),
      tablet: (_) => ReadingCardTablet(reading: reading, dailyConsumption: dailyConsumption,),
    );
  }
}

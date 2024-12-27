import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/models/base/daily_consumption.dart';
import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_narrow.dart';
import 'package:zaehlerstand/src/widgets/responsive/reading_card/reading_card_wide.dart';
import 'package:zaehlerstand_models/zaehlerstand_models.dart';

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
        mobile: (_) => OrientationLayoutBuilder(
              portrait: (context) => ReadingCardWide(reading: reading, dailyConsumption: dailyConsumption),
              landscape: (context) => ReadingCardNarrow(reading: reading, dailyConsumption: dailyConsumption),
            ),
        tablet: (_) => ReadingCardWide(reading: reading, dailyConsumption: dailyConsumption));
  }
}

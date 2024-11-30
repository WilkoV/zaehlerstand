import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_meter_reading_progress_indicator_mobile/add_meter_reading_progress_indicator_mobile.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_meter_reading_progress_indicator_mobile/add_meter_reading_progress_indicator_tablet.dart';

class AddMeterReadingProgressIndicatorResponsiveLayout extends StatelessWidget {
  const AddMeterReadingProgressIndicatorResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const AddMeterReadingProgressIndicatorMobile(),
      tablet: (_) => const AddMeterReadingProgressIndicatorTablet(),
    );
  }
}

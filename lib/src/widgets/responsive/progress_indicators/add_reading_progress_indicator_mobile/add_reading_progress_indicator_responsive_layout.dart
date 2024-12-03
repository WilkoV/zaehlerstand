import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_reading_progress_indicator_mobile/add_reading_progress_indicator_mobile.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/add_reading_progress_indicator_mobile/add_reading_progress_indicator_tablet.dart';

class AddReadingProgressIndicatorResponsiveLayout extends StatelessWidget {
  const AddReadingProgressIndicatorResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const AddReadingProgressIndicatorMobile(),
      tablet: (_) => const AddReadingProgressIndicatorTablet(),
    );
  }
}

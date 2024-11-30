import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/synchronizing_to_google_sheets_progress_indicator/synchronizing_to_google_sheets_progress_indicator_mobile.dart';
import 'package:zaehlerstand/src/widgets/responsive/progress_indicators/synchronizing_to_google_sheets_progress_indicator/synchronizing_to_google_sheets_progress_indicator_tablet.dart';

class SynchronizingToGoogleSheetsProgressIndicatorResponsiveLayout extends StatelessWidget {
  const SynchronizingToGoogleSheetsProgressIndicatorResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const SynchronizingToGoogleSheetsProgressIndicatorMobile(),
      tablet: (_) => const SynchronizingToGoogleSheetsProgressIndicatorTablet(),
    );
  }
}

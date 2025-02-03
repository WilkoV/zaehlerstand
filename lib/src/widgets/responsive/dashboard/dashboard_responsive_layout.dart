import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_reading_consumption_overview.dart';

class DashboardResponsiveLayout extends StatelessWidget {
  const DashboardResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => const DashboardReadingConsumptionOverview(isTablet: false),
        landscape: (context) => const DashboardReadingConsumptionOverview(isTablet: true),
      ),
      tablet: (_) => const DashboardReadingConsumptionOverview(isTablet: true),
    );
  }
}

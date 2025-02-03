import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/charts/weekly_sum_charts.dart';

class WeeklyChartsResponsiveLayout extends StatelessWidget {
  const WeeklyChartsResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => const WeeklySumChart(doRotate: true, rodWidth: 8),
        landscape: (context) => const WeeklySumChart(doRotate: false, rodWidth: 12),
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: (context) => const WeeklySumChart(doRotate: false, rodWidth: 12),
        landscape: (context) => const WeeklySumChart(doRotate: false, rodWidth: 22),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/charts/monthly_sum_charts.dart';

class MonthlyChartsResponsiveLayout extends StatelessWidget {
  const MonthlyChartsResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => const MonthlySumChart(doRotate: true, rodWidth: 14),
        landscape: (context) => const MonthlySumChart(doRotate: false, rodWidth: 14),
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: (context) => const MonthlySumChart(doRotate: false, rodWidth: 12),
        landscape: (context) => const MonthlySumChart(doRotate: false, rodWidth: 22),
      ),
    );
  }
}

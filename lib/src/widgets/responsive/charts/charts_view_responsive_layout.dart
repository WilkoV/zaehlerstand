import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/charts/monthly_sum_charts.dart';
import 'package:zaehlerstand/src/widgets/charts/charts_view.dart';

class ChartsViewResponsiveLayout extends StatelessWidget {
  const ChartsViewResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => const ChartsView(),
        landscape: (context) => const MonthlySumChart(doRotate: true, rodWidth: 18),
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: (context) => const MonthlySumChart(doRotate: false, rodWidth: 10),
        landscape: (context) => const MonthlySumChart(doRotate: false, rodWidth: 18),
      ),
    );
  }
}

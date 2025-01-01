import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/dashboard/dashboard_mobile_landscape.dart';
import 'package:zaehlerstand/src/widgets/responsive/dashboard/dashboard_mobile_portrait.dart';
import 'package:zaehlerstand/src/widgets/responsive/dashboard/dashboard_tablet_landscape.dart';
import 'package:zaehlerstand/src/widgets/responsive/dashboard/dashboard_tablet_portrait.dart';

class DashboardResponsiveLayout extends StatelessWidget {
  const DashboardResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => DashboardMobilePortrait(),
        landscape: (context) => DashboardMobileLandscape(),
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: (context) => DashboardTabletPortrait(),
        landscape: (context) => DashboardTabletLandscape(),
      ),
    );
  }
}

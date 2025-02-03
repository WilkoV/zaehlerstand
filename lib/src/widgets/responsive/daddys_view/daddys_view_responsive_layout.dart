
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/daddys_view/daddys_view_mobile_landscape.dart';
import 'package:zaehlerstand/src/widgets/responsive/daddys_view/daddys_view_mobile_portrait.dart';
import 'package:zaehlerstand/src/widgets/responsive/daddys_view/daddys_view_tablet_landscape.dart';
import 'package:zaehlerstand/src/widgets/responsive/daddys_view/daddys_view_tablet_portrait.dart';

class DaddysViewResponsiveLayout extends StatelessWidget {
  const DaddysViewResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => const DaddysViewMobilePortrait(),
        landscape: (context) => const DaddysViewMobileLandscape(),
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: (context) => const DaddysViewTabletPortrait(),
        landscape: (context) => const DaddysViewTabletLandscape(),
      ),
    );
  }
}

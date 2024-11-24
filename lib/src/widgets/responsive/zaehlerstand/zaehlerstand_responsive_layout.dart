import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_mobile_landscape.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_mobile_portrait.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_tablet_landscape.dart';
import 'package:zaehlerstand/src/widgets/responsive/zaehlerstand/zaehlerstand_tablet_portrait.dart';

class ZaehlerstandResponsiveLayout extends StatelessWidget {
  const ZaehlerstandResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (_) => OrientationLayoutBuilder(
        portrait: (context) => ZaehlerstandMobilePortrait(),
        landscape: (context) => ZaehlerstandMobileLandscape(),
      ),
      tablet: (_) => OrientationLayoutBuilder(
        portrait: (context) => ZaehlerstandTabletPortrait(),
        landscape: (context) => ZaehlerstandTabletLandscape(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

abstract class DaddysViewBase extends StatelessWidget {
  final bool showReading;
  final bool showConsumption;
  final bool showTemperature;
  final bool showFeelsLike;

  const DaddysViewBase({
    super.key,
    required this.showConsumption,
    required this.showReading,
    required this.showTemperature,
    required this.showFeelsLike,
  });

  double getMinWidth(BuildContext context, int years) {
    double screenWidth = MediaQuery.of(context).size.width;
    return years < 4 ? screenWidth : screenWidth + ((years - 3) * 200);
  }

  double getRowHeightFactor(double factor) {
    if (showConsumption) {
      factor += 1.2;
    }

    if (showReading) {
      factor += 1.2;
    }

    if (showTemperature) {
      factor += 1.2;
    }

    if (showFeelsLike) {
      factor += 1.2;
    }
    return factor;
  }
}

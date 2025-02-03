import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zaehlerstand/src/app/app_configuration.dart';

abstract class DaddysViewBase extends StatelessWidget {
  final bool showReading;
  final bool showConsumption;
  final bool showTemperature;
  final bool showFeelsLike;
  final int minColumns;
  final bool showLongNames;
  final bool isTablet;

  const DaddysViewBase({
    super.key,
    required this.minColumns,
    required this.showLongNames,
    required this.showConsumption,
    required this.showReading,
    required this.showTemperature,
    required this.showFeelsLike,
    required this.isTablet,
  });

  double getMinWidth(BuildContext context, int noOfColumns) {
    double screenWidth = MediaQuery.of(context).size.width;
    double newScreenWidth = noOfColumns < minColumns ? screenWidth : screenWidth + ((noOfColumns - minColumns) * 200);
    return newScreenWidth;
  }

  double getRowHeightFactor() {
    double factor = AppConfiguration.getRowHeightFactor(isTablet);

    if (showConsumption) {
      factor += AppConfiguration.getRowHeightFactor(isTablet);
    }

    if (showReading) {
      factor += AppConfiguration.getRowHeightFactor(isTablet);
    }

    if (showTemperature) {
      factor += AppConfiguration.getRowHeightFactor(isTablet);
    }

    if (showFeelsLike) {
      factor += AppConfiguration.getRowHeightFactor(isTablet);
    }
    return factor;
  }

  String getMonthName(String month) {
    DateTime date = DateTime(2023, int.parse(month), 1);
    return showLongNames ? DateFormat.MMMM('de_DE').format(date) : DateFormat.MMM('de_DE').format(date);
  }

  String getDayName(String day) {
    final int target = int.parse(day);
    final Map<int, String> daysOfWeek = showLongNames
        ? {
            0: "Montag",
            1: "Dienstag",
            2: "Mittwoch",
            3: "Donnerstag",
            4: "Freitag",
            5: "Samstag",
            6: "Sonntag",
          }
        : {
            0: "Mo.",
            1: "Di.",
            2: "Mi.",
            3: "Do.",
            4: "Fr.",
            5: "Sa.",
            6: "So.",
          };

    return daysOfWeek[target]!;
  }
}

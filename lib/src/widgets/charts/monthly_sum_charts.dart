import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/app/app_theme.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/charts/charts_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class MonthlySumChart extends ChartsBase {
  const MonthlySumChart({
    super.key,
    required super.doRotate,
    required super.rodWidth,
  });

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool isDarkMode = settingsProvider.isDarkMode;
    final int rotationQuarterTurns = doRotate ? 1 : 0;
    List<Color> colors = AppTheme.getChartColors(isDarkMode: isDarkMode);

    // Use FutureBuilder to wait for the monthlyChartData
    return FutureBuilder<List<ChartBasicAggregation>>(
      future: dataProvider.monthlyChartData,
      builder: (context, snapshot) {
        // While waiting for data, show a loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // If there was an error, display a message.
        if (snapshot.hasError) {
          return Center(
            child: Text('Fehler beim Laden der Daten', style: Theme.of(context).textTheme.bodyLarge),
          );
        }
        // Once the data is loaded, check if it's empty.
        final monthlyChartData = snapshot.data ?? <ChartBasicAggregation>[];
        if (monthlyChartData.isEmpty) {
          return Center(
            child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        // Create a color mapping for the years present in the data.
        Map<int, Color> colorMap = _getColors(monthlyChartData, colors);
        // Group the data by month and year.
        Map<int, Map<int, ChartBasicAggregation>> groupedData = _createGroupedData(monthlyChartData, colorMap);

        // Calculate an adjusted rod width so that the bars don’t get too wide.
        final double adjustedRodWidth = rodWidth * 4 / colorMap.length;

        // Generate a BarChartGroupData list from the grouped data.
        List<BarChartGroupData> barGroups = groupedData.entries.map((entry) {
          int month = entry.key;
          Map<int, ChartBasicAggregation> yearlyData = entry.value;

          return BarChartGroupData(
            x: month,
            barRods: yearlyData.entries.map((yearEntry) {
              return BarChartRodData(
                toY: yearEntry.value.consumptionSum.toDouble(),
                color: colorMap[yearEntry.value.year]!,
                width: adjustedRodWidth,
              );
            }).toList(),
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              rotationQuarterTurns: rotationQuarterTurns,
              barGroups: barGroups,
              alignment: BarChartAlignment.spaceEvenly,
              maxY: _getMaxY(barGroups),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 25,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(), style: Theme.of(context).textTheme.bodySmall);
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          getMonthName(value.toInt(), false),
                          style: Theme.of(context).textTheme.bodySmall!,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toStringAsFixed(0)} m³',
                      TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                        fontWeight: FontWeight.bold,
                        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Groups the data by month (1-12) and then by year.
  Map<int, Map<int, ChartBasicAggregation>> _createGroupedData(
      List<ChartBasicAggregation> monthlyChartData, Map<int, Color> colorMap) {
    Map<int, Map<int, ChartBasicAggregation>> groupedData = {};

    // Determine all unique years in the dataset.
    Set<int> allYears = monthlyChartData.map((e) => e.year).toSet();

    // Ensure each month (1-12) exists.
    for (int month = 1; month <= 12; month++) {
      groupedData[month] = {};

      for (int year in allYears) {
        // Look for an entry for this month and year.
        ChartBasicAggregation? existingEntry = monthlyChartData.firstWhere(
          (aggregation) => aggregation.bucket == month && aggregation.year == year,
          orElse: () => ChartBasicAggregation(year: year, bucket: month, consumptionSum: 0, consumptionAvg: 0),
        );
        groupedData[month]![year] = existingEntry;
      }
    }
    return groupedData;
  }

  /// Creates a mapping between a year and a color.
  Map<int, Color> _getColors(List<ChartBasicAggregation> monthlyChartData, List<Color> colors) {
    Map<int, Color> colorMap = {};
    for (final ChartBasicAggregation entry in monthlyChartData) {
      // Assign a color to the year if one hasn't been assigned yet.
      colorMap.putIfAbsent(entry.year, () => colors[colorMap.length]);
      // Optionally, limit the number of distinct colors (e.g., to 4) if needed.
      if (colorMap.length > 4) {
        break;
      }
    }
    return colorMap;
  }

  /// Returns the month name based on the month number.
  String getMonthName(int month, bool showLongNames) {
    DateTime date = DateTime(2023, month, 1);
    return showLongNames ? DateFormat.MMMM('de_DE').format(date) : DateFormat.MMM('de_DE').format(date);
  }

  /// Calculates the maximum y-value for the chart.
  double _getMaxY(List<BarChartGroupData> barGroups) {
    double maxY = 0;
    for (var group in barGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) {
          maxY = rod.toY;
        }
      }
    }
    return (double.parse((maxY / 100).toStringAsFixed(0)) + .5) * 100;
  }
}

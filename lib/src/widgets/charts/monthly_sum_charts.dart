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
    final List<ReadingDetailAggregation> monthlyChartData = dataProvider.monthlyChartData;
    final int rotationQuarterTurns = doRotate ? 1 : 0;

    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool isDarkMode = settingsProvider.isDarkMode;

    if (monthlyChartData.isEmpty) {
      return Center(
        child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
      );
    }
    List<Color> colors = AppTheme.getChartColors(isDarkMode: isDarkMode);
    Map<int, Color> colorMap = _getColors(monthlyChartData, colors);
    Map<int, Map<int, ReadingDetailAggregation>> groupedData = _createGroupedData(monthlyChartData, colorMap);

    final double adjustedRodWidth = rodWidth * 4 / colorMap.length;

    List<BarChartGroupData> barGroups = groupedData.entries.map((entry) {
      int month = entry.key;
      Map<int, ReadingDetailAggregation> yearlyData = entry.value;

      return BarChartGroupData(
        x: month,
        barRods: yearlyData.entries.map((yearEntry) {
          return BarChartRodData(
            toY: yearEntry.value.consumptionSum?.toDouble() ?? 0,
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
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
  }

  Map<int, Map<int, ReadingDetailAggregation>> _createGroupedData(List<ReadingDetailAggregation> monthlyChartData, Map<int, Color> colorMap) {
    Map<int, Map<int, ReadingDetailAggregation>> groupedData = {};

    // Find all unique years in the dataset
    Set<int> allYears = monthlyChartData.map((e) => e.year).toSet();

    // Ensure each month (1-12) exists
    for (int month = 1; month <= 12; month++) {
      groupedData[month] = {};

      for (int year in allYears) {
        // Find the existing entry for this month/year, if any
        ReadingDetailAggregation? existingEntry = monthlyChartData.firstWhere(
          (e) => e.month == month && e.year == year,
          orElse: () => ReadingDetailAggregation(
            year: year,
            month: month,
            minReading: 0,
            maxReading: 0,
            consumptionSum: 0,
          ),
        );

        groupedData[month]![year] = existingEntry;
      }
    }

    return groupedData;
  }

  Map<int, Color> _getColors(List<ReadingDetailAggregation> monthlyChartData, List<Color> colors) {
    Map<int, Color> colorMap = {};

    for (final ReadingDetailAggregation entry in monthlyChartData) {
      colorMap.putIfAbsent(entry.year, () => colors[colorMap.length]);

      if (colorMap.length > 4) {
        break;
      }
    }

    return colorMap;
  }

  String getMonthName(int month, bool showLongNames) {
    DateTime date = DateTime(2023, month, 1);
    return showLongNames ? DateFormat.MMMM('de_DE').format(date) : DateFormat.MMM('de_DE').format(date);
  }

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

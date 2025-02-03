import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/app/app_theme.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/charts/charts_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class WeeklySumChart extends ChartsBase {
  const WeeklySumChart({
    super.key,
    required super.doRotate,
    required super.rodWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Obtain the providers.
    final dataProvider = Provider.of<DataProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool isDarkMode = settingsProvider.isDarkMode;
    final int rotationQuarterTurns = doRotate ? 1 : 0;
    List<Color> colors = AppTheme.getChartColors(isDarkMode: isDarkMode);

    // Use a FutureBuilder to wait for weeklyChartData.
    return FutureBuilder<List<ChartBasicAggregation>>(
      future: dataProvider.weeklyChartData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the data.
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Fehler beim Laden der Daten',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        // Once data is available, extract it.
        final weeklyChartData = snapshot.data ?? <ChartBasicAggregation>[];

        if (weeklyChartData.isEmpty) {
          return Center(
            child: Text(
              'Keine Daten gefunden',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        // Create a mapping from week bucket to a color.
        Map<int, Color> colorMap = _getColors(weeklyChartData, colors);

        // Generate the bar groups for the chart.
        List<BarChartGroupData> barGroups = List.generate(53, (index) {
          int weekNumber = index;
          ChartBasicAggregation entry = weeklyChartData.firstWhere(
            (e) => e.bucket == weekNumber,
            orElse: () => ChartBasicAggregation(
              bucket: weekNumber,
              consumptionSum: 0,
              consumptionAvg: 0,
              year: DateTime.now().year,
            ),
          );

          return BarChartGroupData(
            x: weekNumber,
            barRods: [
              BarChartRodData(
                toY: entry.consumptionSum.toDouble(),
                color: colorMap[weekNumber] ?? colors.first,
                width: rodWidth,
              ),
            ],
          );
        });

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
                      return Text(
                        value.toInt().toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() % 5 == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'W${value.toInt()}',
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
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
                  getTooltipColor: (group) => AppTheme.getCharTooltipColor(isDarkMode: isDarkMode),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      'W${group.x}: ${rod.toY.toStringAsFixed(0)} m³',
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

  Map<int, Color> _getColors(List<ChartBasicAggregation> weeklyChartData, List<Color> colors) {
    Map<int, Color> colorMap = {};

    for (final ChartBasicAggregation entry in weeklyChartData) {
      colorMap.putIfAbsent(entry.bucket, () => colors[colorMap.length % colors.length]);
    }

    return colorMap;
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

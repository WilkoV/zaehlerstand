import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DaddysWeeklyDailyView extends DaddysViewBase {
  const DaddysWeeklyDailyView({
    super.key,
    required super.showConsumption,
    required super.showReading,
    required super.showTemperature,
    required super.showFeelsLike,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final weeklyDailyViewData = dataProvider.weeklyAggregationViewData;

        double factor = getRowHeightFactor(1.2);

        if (weeklyDailyViewData.isEmpty) {
          return Center(
            child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        // Extract all unique years for the column headers
        final weeks = weeklyDailyViewData.keys.toList();

        // Generate all periods (days of the year)
        final periods = _getWeeklyDailyPeriodLabels();

        print('yyy $periods');

        // Ensure data exists for all periods in all years
        for (final week in weeks) {
          weeklyDailyViewData[week] ??= {};
          for (final period in periods) {
            weeklyDailyViewData[week]![period];
          }
        }

        // Calculate screen width based on the number of columns that needed to be displayed
        final double screenWidth = getMinWidth(context, weeks.length);

        return Column(
          children: [
            Expanded(
              child: DataTable2(
                minWidth: screenWidth,
                fixedLeftColumns: 1,
                headingTextStyle: Theme.of(context).textTheme.bodyLarge,
                dataTextStyle: Theme.of(context).textTheme.bodyLarge,
                dataRowHeight: Theme.of(context).textTheme.bodyLarge!.fontSize! * factor,
                columns: [
                  const DataColumn2(label: Text(''), size: ColumnSize.M),
                  ...weeks.map((month) => DataColumn2(label: Text(month))),
                ],
                rows: periods.map((period) {
                  return DataRow(
                    cells: [
                      DataCell(Text(getDayName(period))),
                      ...weeks.map((week) {
                        final WeeklyReadingDetail? data = weeklyDailyViewData[week]?[period]?['aggregation'];

                        if (data == null) {
                          return const DataCell(Text('-'));
                        }

                        return DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showConsumption) Text('${data.consumption}m³', style: Theme.of(context).textTheme.bodyLarge),
                              if (showReading) Text('${data.reading}', style: Theme.of(context).textTheme.bodyMedium),
                              if (showTemperature && data.minTemperature != null) Text('${data.minTemperature!.toStringAsFixed(1)}/${data.maxTemperature!.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
                              if (showFeelsLike && data.minFeelsLike != null) Text('${data.minFeelsLike!.toStringAsFixed(1)}/${data.maxFeelsLike!.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> _getWeeklyDailyPeriodLabels() {
    return List.generate(7, (index) {
      int day = index;
      return day.toString().padLeft(2, '0');
    });
  }
}

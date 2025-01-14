import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DaddysMonthlyDailyView extends DaddysViewBase {
  const DaddysMonthlyDailyView({
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
        final monthlyDailyViewData = dataProvider.monthlyDayViewData;

        double factor = getRowHeightFactor(1.2);

        if (monthlyDailyViewData.isEmpty) {
          return Center(
            child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        // Extract all unique years for the column headers
        final months = monthlyDailyViewData.keys.toList();

        // Generate all periods (days of the year)
        final periods = _getMonthlyDailyPeriodLabels();

        // Ensure data exists for all periods in all years
        for (final year in months) {
          monthlyDailyViewData[year] ??= {};
          for (final period in periods) {
            monthlyDailyViewData[year]![period];
          }
        }

        // Calculate screen width based on the number of columns that needed to be displayed
        final double screenWidth = getMinWidth(context, months.length);

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
                  const DataColumn2(label: Text(''), size: ColumnSize.S),
                  ...months.map((month) => DataColumn2(label: Text(getMonthName(month)))),
                ],
                rows: periods.map((period) {
                  return DataRow(
                    cells: [
                      DataCell(Text(period)),
                      ...months.map((day) {
                        final ReadingDetail? data = monthlyDailyViewData[day]?[period]?['readingDetail'];

                        if (data == null) {
                          return const DataCell(Text('-'));
                        }

                        return DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showConsumption && data.consumption != null) Text('${data.consumption!.consumption}m³', style: Theme.of(context).textTheme.bodyLarge),
                              if (showReading) Text('${data.reading.reading}', style: Theme.of(context).textTheme.bodyMedium),
                              if (showTemperature && data.weatherInfo != null)
                                Text('${data.weatherInfo!.minTemperature.toStringAsFixed(1)}/${data.weatherInfo!.maxTemperature.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
                              if (showFeelsLike && data.weatherInfo != null) Text('${data.weatherInfo!.minFeelsLike.toStringAsFixed(1)}/${data.weatherInfo!.maxFeelsLike.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
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

  List<String> _getMonthlyDailyPeriodLabels() {
    return List.generate(31, (index) {
      int day = index + 1;
      return day.toString().padLeft(2, '0');
    });
  }
}

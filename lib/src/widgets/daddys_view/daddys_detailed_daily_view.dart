import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';

class DaddysDetailedDailyView extends DaddysViewBase {
  const DaddysDetailedDailyView({
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
        final yearlyViewData = dataProvider.yearlyViewData;

        double factor = getRowHeightFactor(1.2);

        if (yearlyViewData.isEmpty) {
          return Center(
            child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        // Extract all unique years for the column headers
        final years = yearlyViewData.keys.toList();

        // Generate all periods (days of the year)
        final periods = _getYearlyPeriodLabels();

        // Ensure data exists for all periods in all years
        for (final year in years) {
          yearlyViewData[year] ??= {};
          for (final period in periods) {
            yearlyViewData[year]![period];
          }
        }

        // Calculate screen width based on the number of columns that needed to be displayed
        double screenWidth = getMinWidth(context, years.length);

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
                  ...years.map((year) => DataColumn2(label: Text(year))),
                ],
                rows: periods.map((period) {
                  return DataRow(
                    cells: [
                      DataCell(Text(period)),
                      ...years.map((year) {
                        final data = yearlyViewData[year]?[period];

                        if (data == null) {
                          return const DataCell(Text('-'));
                        }

                        return DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showConsumption) Text('${data['consumption']}m³', style: Theme.of(context).textTheme.bodyLarge),
                              if (showReading) Text('${data['reading']}', style: Theme.of(context).textTheme.bodyMedium),
                              if (showTemperature && data['minTemperature'] != null) Text('${data['maxTemperature'].toStringAsFixed(1)}/${data['minTemperature'].toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
                              if (showFeelsLike && data['minFeelsLike'] != null) Text('${data['maxFeelsLike'].toStringAsFixed(1)}/${data['minFeelsLike'].toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
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

  List<String> _getYearlyPeriodLabels() {
    final int year = DateTime(2024, 1, 1).year;
    final int daysInYear = DateTime(year, 12, 31).difference(DateTime(year, 1, 1)).inDays + 1;

    return List.generate(daysInYear, (index) {
      final date = DateTime(year, 1, 1).add(Duration(days: index));
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
    });
  }
}

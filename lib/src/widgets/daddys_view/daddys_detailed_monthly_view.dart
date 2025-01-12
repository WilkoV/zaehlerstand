import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';

class DaddysDetailedMonthlyView extends DaddysViewBase {
  const DaddysDetailedMonthlyView({
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
        final monthlyViewData = dataProvider.monthlyViewData ;

        double factor = getRowHeightFactor(1.2);

        if (monthlyViewData.isEmpty) {
          return Center(
            child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        // Extract all unique years for the column headers
        final months = monthlyViewData.keys.toList();

        // Generate all periods (days of the year)
        final periods = _getDailyPeriodLabels();

        // Ensure data exists for all periods in all years
        for (final year in months) {
          monthlyViewData[year] ??= {};
          for (final period in periods) {
            monthlyViewData[year]![period];
          }
        }
        
        final

        // Calculate screen width based on the number of columns that needed to be displayed
        double screenWidth = getMinWidth(context, months.length);

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
                  ...months.map((month) => DataColumn2(label: Text(_getMonthName(month)))),
                ],
                rows: periods.map((period) {
                  return DataRow(
                    cells: [
                      DataCell(Text(period)),
                      ...months.map((day) {
                        final data = monthlyViewData[day]?[period];

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

  String _getMonthName(String month) {
    DateTime date = DateTime(2024, int.parse(month));
    return DateFormat.MMMM('de_DE').format(date);
  }

  List<String> _getDailyPeriodLabels() {
    return List.generate(31, (index) {
      int day = index + 1;
      return day.toString().padLeft(2, '0');
    });
  }
}

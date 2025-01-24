import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DaddysYearlyAvgView extends DaddysViewBase {
  const DaddysYearlyAvgView({
    super.key,
    required super.minColumns,
    required super.showLongNames,
    required super.showConsumption,
    required super.showReading,
    required super.showTemperature,
    required super.showFeelsLike,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        final monthlyAggregationViewData = dataProvider.monthlyAggregationViewData;

        double factor = getRowHeightFactor(1.2);

        // This view needs to rows for the reading
        if (showReading) {
          factor += 1.2;
        }

        if (monthlyAggregationViewData.isEmpty) {
          return Center(
            child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
          );
        }

        // Extract all unique years for the column headers
        final years = monthlyAggregationViewData.keys.toList();

        // Generate all periods (days of the year)
        final periods = _getMonthlySumPeriodLabels();

        // Ensure data exists for all periods in all years
        for (final year in years) {
          monthlyAggregationViewData[year] ??= {};
          for (final period in periods) {
            monthlyAggregationViewData[year]![period];
          }
        }

        // Calculate screen width based on the number of columns that needed to be displayed
        final double screenWidth = getMinWidth(context, years.length);

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
                      DataCell(Text(getMonthName(period))),
                      ...years.map((day) {
                        final ReadingDetailAggregation? data = monthlyAggregationViewData[day]?[period]?['aggregation']!;

                        if (data == null) {
                          return const DataCell(Text('-'));
                        }

                        return DataCell(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showConsumption) Text('${data.consumptionAvg!.toStringAsFixed(1)}m³', style: Theme.of(context).textTheme.bodyLarge),
                              if (showReading) Text('${data.minReading} -', style: Theme.of(context).textTheme.bodyMedium),
                              if (showReading) Text('${data.maxReading}', style: Theme.of(context).textTheme.bodyMedium),
                              if (showTemperature && data.minTemperature != null) Text('${data.avgMinTemperature!.toStringAsFixed(1)}/${data.avgMaxTemperature!.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
                              if (showFeelsLike && data.minFeelsLike != null) Text('${data.avgMinFeelsLike!.toStringAsFixed(1)}/${data.avgMaxFeelsLike!.toStringAsFixed(1)}°C', style: Theme.of(context).textTheme.bodyMedium),
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

  List<String> _getMonthlySumPeriodLabels() {
    return List.generate(12, (index) {
      int day = index + 1;
      return day.toString().padLeft(2, '0');
    });
  }
}

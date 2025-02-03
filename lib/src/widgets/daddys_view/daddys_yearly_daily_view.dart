import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DaddysYearlyDailyView extends DaddysViewBase {
  const DaddysYearlyDailyView({
    super.key,
    required super.minColumns,
    required super.showLongNames,
    required super.showConsumption,
    required super.showReading,
    required super.showTemperature,
    required super.showFeelsLike,
    required super.isTablet,
  });
  @override
  Widget build(BuildContext context) {
    final ScrollController verticalScrollController = ScrollController();

    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return FutureBuilder<Map<String, Map<String, ReadingDetail?>>>(
          future: dataProvider.yearlyDayViewData,
          builder: (context, snapshot) {
            // While waiting for the data, display a loading indicator.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If an error occurs, show an error message.
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Fehler: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            // If no data is returned, show a "no data" message.
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Keine Daten gefunden',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            final yearlyDailyViewData = snapshot.data!;
            final periods = _getYearlyDailyPeriodLabels();
            double factor = getRowHeightFactor();

            // Calculate the index of the current date label
            final today = DateTime.now();
            final currentDateLabel = '${today.day.toString().padLeft(2, '0')}.${today.month.toString().padLeft(2, '0')}';
            const int offset = 5;
            final currentIndex = periods.indexOf(currentDateLabel) - offset;

            // Scroll to the current date after the first frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (currentIndex > 5) {
                final rowHeight = Theme.of(context).textTheme.bodyLarge!.fontSize! * factor;
                final targetScrollOffset = currentIndex * rowHeight;
                verticalScrollController.jumpTo(targetScrollOffset);
              }
            });

            // Extract all unique years for the column headers
            final years = yearlyDailyViewData.keys.toList();

            return Column(
              children: [
                Expanded(
                  child: DataTable2(
                    scrollController: verticalScrollController,
                    minWidth: getMinWidth(context, years.length),
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
                            final ReadingDetail? data = yearlyDailyViewData[year]?[period];

                            if (data == null) {
                              return const DataCell(Text('-'));
                            }

                            return DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (showConsumption && data.consumption != null)
                                    Text(
                                      '${data.consumption!.consumption}m³',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  if (showReading)
                                    Text(
                                      '${data.reading.reading}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (showTemperature && data.weatherInfo != null)
                                    Text(
                                      '${data.weatherInfo!.minTemperature.toStringAsFixed(1)}/${data.weatherInfo!.maxTemperature.toStringAsFixed(1)}°C',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (showFeelsLike && data.weatherInfo != null)
                                    Text(
                                      '${data.weatherInfo!.minFeelsLike.toStringAsFixed(1)}/${data.weatherInfo!.maxFeelsLike.toStringAsFixed(1)}°C',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
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
      },
    );
  }

  List<String> _getYearlyDailyPeriodLabels() {
    final int year = DateTime(2024, 1, 1).year;
    final int daysInYear = DateTime(year, 12, 31).difference(DateTime(year, 1, 1)).inDays + 1;

    return List.generate(daysInYear, (index) {
      final date = DateTime(year, 1, 1).add(Duration(days: index));
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
    });
  }
}

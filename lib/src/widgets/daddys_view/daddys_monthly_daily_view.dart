import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DaddysMonthlyDailyView extends DaddysViewBase {
  const DaddysMonthlyDailyView({
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
    final ScrollController verticalScrollController = ScrollController();

    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return FutureBuilder<Map<String, Map<String, Map<String, ReadingDetail?>>>>(
          future: dataProvider.monthlyDayViewData,
          builder: (context, snapshot) {
            // Show a loading indicator while waiting for data.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle errors if any occurred during the data fetch.
            if (snapshot.hasError) {
              return Center(
                child: Text('Fehler: ${snapshot.error}', style: Theme.of(context).textTheme.bodyLarge),
              );
            }

            // If no data is available, show a message.
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
              );
            }

            final monthlyDailyViewData = snapshot.data!;
            double factor = getRowHeightFactor(1.2);

            // Extract all unique months for the column headers.
            final months = monthlyDailyViewData.keys.toList();

            // Generate all periods (e.g. days of the month)
            final periods = _getMonthlyDailyPeriodLabels();

            // Ensure data exists for all periods in all months.
            for (final month in months) {
              monthlyDailyViewData[month] ??= {};
              for (final period in periods) {
                monthlyDailyViewData[month]![period];
              }
            }

            final today = DateTime.now();
            final currentDateLabel = today.day.toString().padLeft(2, '0');
            const int offset = 5;
            final currentIndex = periods.indexOf(currentDateLabel) - offset;

            // Scroll to the current period after the frame is rendered.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (currentIndex >= 0 && currentIndex < periods.length) {
                final rowHeight = Theme.of(context).textTheme.bodyLarge!.fontSize! * factor;
                final targetScrollOffset = currentIndex * rowHeight;
                verticalScrollController.jumpTo(targetScrollOffset);
              }
            });

            // Calculate screen width based on the number of columns needed.
            final double screenWidth = getMinWidth(context, months.length);

            return Column(
              children: [
                Expanded(
                  child: DataTable2(
                    minWidth: screenWidth,
                    scrollController: verticalScrollController,
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
                          ...months.map((month) {
                            final ReadingDetail? data = monthlyDailyViewData[month]?[period]?['readingDetail'];

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

  List<String> _getMonthlyDailyPeriodLabels() {
    return List.generate(31, (index) {
      int day = index + 1;
      return day.toString().padLeft(2, '0');
    });
  }
}

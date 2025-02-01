import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/daddys_view/daddys_view_base.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DaddysYearlySumView extends DaddysViewBase {
  const DaddysYearlySumView({
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
        return FutureBuilder<Map<String, Map<String, Map<String, ReadingDetailAggregation?>>>>(
          future: dataProvider.monthlyAggregationViewData,
          builder: (context, snapshot) {
            // While the asynchronous operation is in progress, show a loading indicator.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If an error occurred, display an error message.
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Fehler: ${snapshot.error}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            // If no data is found, show a message.
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'Keine Daten gefunden',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            // Data has been fetched successfully.
            final monthlyAggregationViewData = snapshot.data!;
            double factor = getRowHeightFactor(1.2);

            // Adjust row height if showing readings.
            if (showReading) {
              factor += 1.2;
            }

            // Extract all unique years for the column headers.
            final years = monthlyAggregationViewData.keys.toList();

            // Generate all periods (months).
            final periods = _getMonthlySumPeriodLabels();

            // Calculate the index for the current month.
            final today = DateTime.now();
            final currentMonthIndex = today.month - 1;

            // Scroll to the current month after the first frame.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (currentMonthIndex > 5) {
                final rowHeight = Theme.of(context).textTheme.bodyLarge!.fontSize! * factor;
                final targetScrollOffset = (currentMonthIndex - 5) * rowHeight;
                verticalScrollController.jumpTo(targetScrollOffset);
              }
            });

            // Ensure data exists for all periods in all years.
            for (final year in years) {
              monthlyAggregationViewData[year] ??= {};
              for (final period in periods) {
                monthlyAggregationViewData[year]![period];
              }
            }

            // Calculate screen width based on the number of columns.
            final double screenWidth = getMinWidth(context, years.length);

            return Column(
              children: [
                Expanded(
                  child: DataTable2(
                    scrollController: verticalScrollController,
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
                          DataCell(
                            Text(
                              getMonthName(period),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          ...years.map((year) {
                            final ReadingDetailAggregation? data = monthlyAggregationViewData[year]?[period]?['aggregation'];

                            if (data == null) {
                              return const DataCell(Text('-'));
                            }

                            return DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (showConsumption)
                                    Text(
                                      '${data.consumptionSum}m³',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  if (showReading)
                                    Text(
                                      '${data.minReading} -',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (showReading)
                                    Text(
                                      '${data.maxReading}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (showTemperature && data.minTemperature != null)
                                    Text(
                                      '${data.minTemperature!.toStringAsFixed(1)}/${data.maxTemperature!.toStringAsFixed(1)}°C',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  if (showFeelsLike && data.minFeelsLike != null)
                                    Text(
                                      '${data.minFeelsLike!.toStringAsFixed(1)}/${data.maxFeelsLike!.toStringAsFixed(1)}°C',
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

  List<String> _getMonthlySumPeriodLabels() {
    return List.generate(12, (index) {
      final month = index + 1;
      return month.toString().padLeft(2, '0');
    });
  }
}

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_reading_avg_consumption_element.dart';
import 'package:zaehlerstand/src/widgets/dashboard/dashboard_reading_consumption_element.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class DashboardReadingConsumptionOverview extends StatelessWidget {
  final bool isTablet;

  const DashboardReadingConsumptionOverview({
    super.key,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        double factor = getRowHeightFactor(
          1.2,
          settingsProvider.showConsumption,
          settingsProvider.showReading,
          settingsProvider.showTemperature,
          settingsProvider.showFeelsLike,
        );

        return Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            // Fetch futures before FutureBuilder
            final Future<List<ReadingDetail>> dailyFuture = _getDailyReadingDetails(dataProvider, isTablet ? settingsProvider.dashboardDaysTablet : settingsProvider.dashboardDaysMobile);
            final Future<List<ReadingDetailAggregation>> monthlyFuture = _getMonthlyAggregations(dataProvider, isTablet ? settingsProvider.dashboardMonthsTablet : settingsProvider.dashboardMonthsMobile);
            final Future<List<ReadingDetailAggregation>> yearlyFuture = _getYearlyAggregations(dataProvider, isTablet ? settingsProvider.dashboardYearsTablet : settingsProvider.dashboardYearsMobile);

            return FutureBuilder<List<ReadingDetail>>(
              future: dailyFuture,
              builder: (context, dailySnapshot) {
                if (dailySnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (dailySnapshot.hasError) {
                  return const Center(child: Text('Fehler beim Laden der täglichen Daten'));
                }

                List<ReadingDetail> dailyRowData = dailySnapshot.data ?? [];

                if (dailyRowData.isEmpty) {
                  return Center(
                    child: Text(
                      'Keine Daten gefunden',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                return FutureBuilder<List<ReadingDetailAggregation>>(
                  future: monthlyFuture,
                  builder: (context, monthlySnapshot) {
                    if (monthlySnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (monthlySnapshot.hasError) {
                      return const Center(child: Text('Fehler beim Laden der monatlichen Daten'));
                    }

                    List<ReadingDetailAggregation> monthlyRow = monthlySnapshot.data ?? [];

                    return FutureBuilder<List<ReadingDetailAggregation>>(
                      future: yearlyFuture,
                      builder: (context, yearlySnapshot) {
                        if (yearlySnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (yearlySnapshot.hasError) {
                          return const Center(child: Text('Fehler beim Laden der jährlichen Daten'));
                        }

                        List<ReadingDetailAggregation> yearlyRow = yearlySnapshot.data ?? [];
                        int maxElements = isTablet ? 4 : 3;

                        return DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          dataTextStyle: Theme.of(context).textTheme.bodyLarge,
                          dataRowHeight: Theme.of(context).textTheme.bodyLarge!.fontSize! * factor,
                          columns: [
                            const DataColumn2(label: Text(''), size: ColumnSize.S),
                            for (var i = 0; i < maxElements; i++) const DataColumn2(label: Text(''), size: ColumnSize.L),
                          ],
                          rows: [
                            DataRow(cells: _buildDailyDataCells(context, dailyRowData)),
                            DataRow(cells: _buildMonthlySumDataCells(context, monthlyRow)),
                            DataRow(cells: _buildMonthlyAvgDataCells(context, monthlyRow)),
                            DataRow(cells: _buildYearlyDataCells(context, yearlyRow)),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  List<DataCell> _buildDailyDataCells(BuildContext context, List<ReadingDetail> dailyData) {
    int maxElements = isTablet ? 4 : 3;

    List<DataCell> dataCells = [
      DataCell(Text('Tag', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in dailyData)
        DataCell(
          DashboardReadingConsumptionElement(
            isTablet: isTablet,
            consumption: data.consumption?.consumption,
            reading: data.reading.reading,
            minTemperature: data.weatherInfo?.minTemperature,
            maxTemperature: data.weatherInfo?.maxTemperature,
            minFeelsLike: data.weatherInfo?.minFeelsLike,
            maxFeelsLike: data.weatherInfo?.maxFeelsLike,
            compareConsumptionWith: dailyData.first == data ? null : dailyData.first.consumption!.consumption,
            label: data.reading.getFormattedDate(),
          ),
        ),
      for (var i = dailyData.length; i < maxElements; i++)
        DataCell(DashboardReadingConsumptionElement(
          isTablet: isTablet,
        )),
    ];
    return dataCells;
  }

  List<DataCell> _buildMonthlySumDataCells(BuildContext context, List<ReadingDetailAggregation> monthlyData) {
    int maxElements = isTablet ? 4 : 3;

    List<DataCell> dataCells = [
      DataCell(Text('Monat \u2211', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in monthlyData)
        DataCell(
          DashboardReadingConsumptionElement(
            isTablet: isTablet,
            consumption: data.consumptionSum,
            minReading: data.minReading,
            maxReading: data.maxReading,
            minTemperature: data.minTemperature,
            maxTemperature: data.maxTemperature,
            minFeelsLike: data.minFeelsLike,
            maxFeelsLike: data.maxFeelsLike,
            compareConsumptionWith: monthlyData.first == data ? null : monthlyData.first.consumptionSum,
            label: '${data.year}.${data.month.toString().padLeft(2, '0')}',
          ),
        ),
      for (var i = monthlyData.length; i < maxElements; i++) DataCell(DashboardReadingConsumptionElement(isTablet: isTablet)),
    ];
    return dataCells;
  }

  List<DataCell> _buildMonthlyAvgDataCells(BuildContext context, List<ReadingDetailAggregation> monthlyData) {
    int maxElements = isTablet ? 4 : 3;
    List<DataCell> dataCells = [
      DataCell(Text('Monat \u2205', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in monthlyData)
        DataCell(
          DashboardReadingAvgConsumptionElement(
            isTablet: isTablet,
            consumption: data.consumptionAvg,
            minReading: data.minReading,
            maxReading: data.maxReading,
            minTemperature: data.avgMinTemperature,
            maxTemperature: data.avgMaxTemperature,
            minFeelsLike: data.avgMinFeelsLike,
            maxFeelsLike: data.avgMaxFeelsLike,
            compareConsumptionWith: monthlyData.first == data ? null : monthlyData.first.consumptionAvg,
            label: '${data.year}.${data.month.toString().padLeft(2, '0')}',
          ),
        ),
      for (var i = monthlyData.length; i < maxElements; i++) DataCell(DashboardReadingConsumptionElement(isTablet: isTablet)),
    ];
    return dataCells;
  }

  List<DataCell> _buildYearlyDataCells(BuildContext context, List<ReadingDetailAggregation> yearlyData) {
    int maxElements = isTablet ? 4 : 3;

    List<DataCell> dataCells = [
      DataCell(Text('Jahr', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in yearlyData)
        DataCell(
          DashboardReadingConsumptionElement(
            isTablet: isTablet,
            consumption: data.consumptionSum,
            minReading: data.minReading,
            maxReading: data.maxReading,
            minTemperature: data.minTemperature,
            maxTemperature: data.maxTemperature,
            minFeelsLike: data.minFeelsLike,
            maxFeelsLike: data.maxFeelsLike,
            compareConsumptionWith: yearlyData.first == data ? null : yearlyData.first.consumptionSum,
            label: '${data.year}',
          ),
        ),
      for (var i = yearlyData.length; i < maxElements; i++) DataCell(DashboardReadingConsumptionElement(isTablet: isTablet)),
    ];
    return dataCells;
  }

  double getRowHeightFactor(double factor, bool showConsumption, bool showReading, bool showTemperature, bool showFeelsLike) {
    if (showConsumption) {
      factor += 1.2;
    }

    if (showReading) {
      factor += 1.5;
      factor += 1.5;
    }

    if (showTemperature) {
      factor += 1.2;
    }

    if (showFeelsLike) {
      factor += 1.2;
    }

    factor += 1.2;

    return factor;
  }

  Future<List<ReadingDetail>> _getDailyReadingDetails(DataProvider dataProvider, List<int> indices) async {
    List<ReadingDetail> daily = [];
    List<ReadingDetail> allReadingDetails = await dataProvider.readingsDetails;

    for (int index in indices) {
      if (allReadingDetails.length >= index) {
        daily.add(allReadingDetails[index - 1]);
      }
    }

    return daily;
  }

  Future<List<ReadingDetailAggregation>> _getMonthlyAggregations(DataProvider dataProvider, List<int> indices) async {
    List<ReadingDetailAggregation> monthly = [];
    List<ReadingDetailAggregation> monthlyAggregationViewDataList = await dataProvider.monthlyAggregationViewDataList;

    for (int index in indices) {
      if (monthlyAggregationViewDataList.length >= index) {
        monthly.add(monthlyAggregationViewDataList[index - 1]);
      }
    }

    return monthly;
  }

  Future<List<ReadingDetailAggregation>> _getYearlyAggregations(DataProvider dataProvider, List<int> indices) async {
    List<ReadingDetailAggregation> yearly = [];

    List<ReadingDetailAggregation> yearlyAggregationViewDataList = await dataProvider.yearlyAggregationViewDataList;

    for (int index in indices) {
      if (yearlyAggregationViewDataList.length >= index) {
        yearly.add(yearlyAggregationViewDataList[index - 1]);
      }
    }

    return yearly;
  }
}

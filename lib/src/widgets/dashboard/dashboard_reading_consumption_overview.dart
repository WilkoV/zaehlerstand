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
        double factor = getRowHeightFactor(1.2, settingsProvider.showConsumption, settingsProvider.showReading, settingsProvider.showTemperature, settingsProvider.showFeelsLike);
        return Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            List<ReadingDetail> dailyRowData = _getDailyReadingDetails(dataProvider, isTablet ? settingsProvider.dashboardDaysTablet : settingsProvider.dashboardDaysMobile);
            List<ReadingDetailAggregation> monthlyRow = _getMonthlyAggregations(dataProvider, isTablet ? settingsProvider.dashboardMonthsTablet : settingsProvider.dashboardMonthsMobile);
            List<ReadingDetailAggregation> yearlyRow = _getYearlyAggregations(dataProvider, isTablet ? settingsProvider.dashboardYearsTablet : settingsProvider.dashboardYearsMobile);

            if (dailyRowData.isEmpty) {
              return Center(
                child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
              );
            }

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
  }

  List<DataCell> _buildDailyDataCells(BuildContext context, List<ReadingDetail> dailyData) {
    int maxElements = isTablet ? 4 : 3;

    List<DataCell> dataCells = [
      DataCell(Text('Tag', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in dailyData)
        DataCell(
          DashboardReadingConsumptionElement(
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
      for (var i = dailyData.length; i < maxElements; i++) const DataCell(DashboardReadingConsumptionElement()),
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
      for (var i = monthlyData.length; i < maxElements; i++) const DataCell(DashboardReadingConsumptionElement()),
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
      for (var i = monthlyData.length; i < maxElements; i++) const DataCell(DashboardReadingConsumptionElement()),
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
      for (var i = yearlyData.length; i < maxElements; i++) const DataCell(DashboardReadingConsumptionElement()),
    ];
    return dataCells;
  }

  double getRowHeightFactor(double factor, bool showConsumption, bool showReading, bool showTemperature, bool showFeelsLike) {
    if (showConsumption) {
      factor += 1.2;
    }

    if (showReading) {
      factor += 1.2;
      factor += 1.2;
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

  List<ReadingDetail> _getDailyReadingDetails(DataProvider dataProvider, List<int> indices) {
    List<ReadingDetail> daily = [];

    for (int index in indices) {
      if (dataProvider.readingsDetails.length >= index) {
        daily.add(dataProvider.readingsDetails[index - 1]);
      }
    }

    return daily;
  }

  List<ReadingDetailAggregation> _getMonthlyAggregations(DataProvider dataProvider, List<int> indices) {
    List<ReadingDetailAggregation> monthly = [];

    for (int index in indices) {
      if (dataProvider.monthlyAggregationViewDataList.length >= index) {
        monthly.add(dataProvider.monthlyAggregationViewDataList[index - 1]);
      }
    }

    return monthly;
  }

  List<ReadingDetailAggregation> _getYearlyAggregations(DataProvider dataProvider, List<int> indices) {
    List<ReadingDetailAggregation> yearly = [];

    for (int index in indices) {
      if (dataProvider.yearlyAggregationViewDataList.length >= index) {
        yearly.add(dataProvider.yearlyAggregationViewDataList[index - 1]);
      }
    }

    return yearly;
  }
}

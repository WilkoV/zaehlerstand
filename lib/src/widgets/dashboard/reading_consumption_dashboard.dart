import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/provider/settings_provider.dart';
import 'package:zaehlerstand/src/widgets/dashboard/reading_avg_consumption_element.dart';
import 'package:zaehlerstand/src/widgets/dashboard/reading_consumption_element.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class ReadingConsumptionDashboard extends StatelessWidget {
  const ReadingConsumptionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        double factor = getRowHeightFactor(1.2, settingsProvider.showConsumption, settingsProvider.showReading, settingsProvider.showTemperature, settingsProvider.showFeelsLike);
        return Consumer<DataProvider>(
          builder: (context, dataProvider, child) {
            List<ReadingDetail> dailyRowData = _getDailyReadingDetails(dataProvider, settingsProvider.dashboardDays);
            List<ReadingDetailAggregation> monthlyRow = _getMonthlyAggregations(dataProvider, settingsProvider.dashboardMonths);

            if (dailyRowData.isEmpty) {
              return Center(
                child: Text('Keine Daten gefunden', style: Theme.of(context).textTheme.bodyLarge),
              );
            }

            return DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              dataTextStyle: Theme.of(context).textTheme.bodyLarge,
              dataRowHeight: Theme.of(context).textTheme.bodyLarge!.fontSize! * factor,
              columns: const [
                DataColumn2(label: Text(''), size: ColumnSize.S),
                DataColumn2(label: Text(''), size: ColumnSize.L),
                DataColumn2(label: Text(''), size: ColumnSize.L),
                DataColumn2(label: Text(''), size: ColumnSize.L),
                DataColumn2(label: Text(''), size: ColumnSize.L),
              ],
              rows: [
                DataRow(
                  cells: _buildDailyDataCells(context, dailyRowData),
                ),
                DataRow(
                  cells: _buildMonthlyDataCells(context, monthlyRow),
                ),
                DataRow(
                  cells: _buildAvgAggregationDataCells(context, monthlyRow),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<DataCell> _buildDailyDataCells(BuildContext context, List<ReadingDetail> dailyData) {
    List<DataCell> dataCells = [
      DataCell(Text('Tag', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in dailyData)
        DataCell(
          ReadingConsumptionElement(
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
      for (var i = dailyData.length; i < 4; i++) const DataCell(ReadingConsumptionElement()),
    ];
    return dataCells;
  }

  List<DataCell> _buildMonthlyDataCells(BuildContext context, List<ReadingDetailAggregation> monthlyData) {
    List<DataCell> dataCells = [
      DataCell(Text('Monat', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in monthlyData)
        DataCell(
          ReadingConsumptionElement(
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
      for (var i = monthlyData.length; i < 4; i++) const DataCell(ReadingConsumptionElement()),
    ];
    return dataCells;
  }

  List<DataCell> _buildAvgAggregationDataCells(BuildContext context, List<ReadingDetailAggregation> monthlyData) {
    List<DataCell> dataCells = [
      DataCell(Text('Durch-schnitt', style: Theme.of(context).textTheme.bodyLarge)),
      for (final data in monthlyData)
        DataCell(
          ReadingAvgConsumptionElement(
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
      for (var i = monthlyData.length; i < 4; i++) const DataCell(ReadingConsumptionElement()),
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
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_element.dart';

class DashboardDailyConsumptionRow extends StatelessWidget {
  const DashboardDailyConsumptionRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('T', style: Theme.of(context).textTheme.headlineLarge),
          dataProvider.dailyConsumptions.isNotEmpty
              ? ReadingConsumptionElement(
                  consumption: dataProvider.dailyConsumptions.first.consumption,
                  consumptionDate: dataProvider.dailyConsumptions.first.date,
                )
              : const ReadingConsumptionElement(),
          dataProvider.dailyConsumptions.length >= 7
              ? ReadingConsumptionElement(
                  consumption: dataProvider.dailyConsumptions[7].consumption,
                  consumptionDate: dataProvider.dailyConsumptions.first.date.subtract(const Duration(days: 7)),
                  compareConsumptionWith: dataProvider.dailyConsumptions.first.consumption,
                )
              : const ReadingConsumptionElement(),
          dataProvider.dailyConsumptions.length >= 30
              ? ReadingConsumptionElement(
                  consumption: dataProvider.dailyConsumptions[30].consumption,
                  consumptionDate: dataProvider.dailyConsumptions.first.date.subtract(const Duration(days: 30)),
                  compareConsumptionWith: dataProvider.dailyConsumptions.first.consumption,
                )
              : const ReadingConsumptionElement(),
          dataProvider.dailyConsumptions.length >= 365
              ? ReadingConsumptionElement(
                  consumption: dataProvider.dailyConsumptions[365].consumption,
                  consumptionDate: dataProvider.dailyConsumptions.first.date.subtract(const Duration(days: 365)),
                  compareConsumptionWith: dataProvider.dailyConsumptions.first.consumption,
                )
              : const ReadingConsumptionElement(),
        ],
      );
    });
  }
}

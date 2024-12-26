import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_element.dart';

class DashboardMonthlyConsumption extends StatelessWidget {
  const DashboardMonthlyConsumption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('M', style: Theme.of(context).textTheme.headlineLarge),
          dataProvider.monthlyConsumptions.isNotEmpty
              ? ReadingConsumptionElement(
                  consumption: dataProvider.monthlyConsumptions.first.consumption,
                  label: '${dataProvider.monthlyConsumptions.first.year}.${dataProvider.monthlyConsumptions.first.month.toString().padLeft(2, '0')}',
                )
              : const ReadingConsumptionElement(),
          dataProvider.monthlyConsumptions.length >= 2
              ? ReadingConsumptionElement(
                  consumption: dataProvider.monthlyConsumptions[1].consumption,
                  label: '${dataProvider.monthlyConsumptions[1].year}.${dataProvider.monthlyConsumptions[1].month.toString().padLeft(2, '0')}',
                  compareConsumptionWith: dataProvider.monthlyConsumptions.first.consumption,
                )
              : const ReadingConsumptionElement(),
          dataProvider.monthlyConsumptions.length >= 12
              ? ReadingConsumptionElement(
                  consumption: dataProvider.monthlyConsumptions[11].consumption,
                  label: '${dataProvider.monthlyConsumptions[11].year}.${dataProvider.monthlyConsumptions[11].month.toString().padLeft(2, '0')}',
                  compareConsumptionWith: dataProvider.monthlyConsumptions.first.consumption,
                )
              : const ReadingConsumptionElement(),
          dataProvider.monthlyConsumptions.length >= 24
              ? ReadingConsumptionElement(
                  consumption: dataProvider.monthlyConsumptions[23].consumption,
                  label: '${dataProvider.monthlyConsumptions[23].year}.${dataProvider.monthlyConsumptions[23].month.toString().padLeft(2, '0')}',
                  compareConsumptionWith: dataProvider.monthlyConsumptions.first.consumption,
                )
              : const ReadingConsumptionElement(),
        ],
      );
    });
  }
}

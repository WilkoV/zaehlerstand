import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_element.dart';

class ReadingConsumptionDashboard extends StatelessWidget {
  const ReadingConsumptionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}

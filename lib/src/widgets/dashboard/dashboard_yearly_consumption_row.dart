import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_element.dart';

class DashboardYearlyConsumption extends StatelessWidget {
  const DashboardYearlyConsumption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      List<int> years = [0, 1, 2, 3];
      return Consumer<DataProvider>(builder: (context, dataProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('J', style: Theme.of(context).textTheme.headlineLarge),
            ...years.map((year) {
              return dataProvider.yearlyConsumptions.length > year
                  ? ReadingConsumptionElement(
                      consumption: dataProvider.yearlyConsumptions[year].consumption,
                      label: '${dataProvider.yearlyConsumptions[year].year}',
                      compareConsumptionWith: dataProvider.yearlyConsumptions.first.consumption,
                    )
                  : ReadingConsumptionElement(label: '${DateTime.now().subtract(Duration(days: year)).year}');
            }),
          ],
        );
      });
    });
  }
}

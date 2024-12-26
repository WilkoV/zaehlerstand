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
      List<int> months = [0, 1, 12, 24];
      return Consumer<DataProvider>(builder: (context, dataProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('M', style: Theme.of(context).textTheme.headlineLarge),
            ...months.map((month) {
              return dataProvider.monthlyConsumptions.length > month
                  ? ReadingConsumptionElement(
                      consumption: dataProvider.monthlyConsumptions[month].consumption,
                      label: '${dataProvider.monthlyConsumptions[month].year}.${dataProvider.monthlyConsumptions[month].month.toString().padLeft(2, '0')}',
                      compareConsumptionWith: dataProvider.monthlyConsumptions.first.consumption,
                    )
                  : ReadingConsumptionElement(
                      label: '${DateTime.now().subtract(Duration(days: month)).year}.${DateTime.now().subtract(Duration(days: month)).month.toString().padLeft(2, '0')}',
                    );
            }),
          ],
        );
      });
    });
  }
}

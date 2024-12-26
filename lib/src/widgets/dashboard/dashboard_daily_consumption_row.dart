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
    List<int> days = [0, 7, 30, 365];
    return Consumer<DataProvider>(builder: (context, dataProvider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('T', style: Theme.of(context).textTheme.headlineLarge),
          ...days.map((day) {
            return dataProvider.dailyConsumptions.length >= day
                ? ReadingConsumptionElement(
                    consumption: dataProvider.dailyConsumptions[day].consumption,
                    consumptionDate: dataProvider.dailyConsumptions.first.date.subtract(Duration(days: day)),
                    compareConsumptionWith: dataProvider.dailyConsumptions.first.consumption,
                  )
                :  ReadingConsumptionElement(
                    label: '${DateTime.now().subtract(Duration(days: day)).day}.${DateTime.now().subtract(Duration(days: day)).month.toString().padLeft(2, '0')}.${DateTime.now().subtract(Duration(days: day)).year}',
                  );
          }),
        ],
      );
    });
  }
}

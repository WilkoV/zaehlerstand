import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaehlerstand/src/provider/data_provider.dart';
import 'package:zaehlerstand/src/widgets/data_widgets/reading_consumption_element.dart';
import 'package:zaehlerstand_common/zaehlerstand_common.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, child) {
        List<Map<String, dynamic>> elements = [];
        List<int> days = [0, 7, 30, 365];

        elements.add(<String, dynamic>{
          'type': 'type',
          'label': 'T',
        });

        for (int day in days) {
          if (dataProvider.dailyConsumptions.length > day) {
            String label = ReadingLogic.formatDate(dataProvider.dailyConsumptions.first.date.subtract(Duration(days: day)));
            elements.add({
              'type': 'day',
              'consumption': dataProvider.dailyConsumptions[day].consumption,
              'label': label,
              'compareWith': dataProvider.dailyConsumptions.first.consumption,
            });
          } else {
            elements.add({
              'type': 'default',
              'label': ReadingLogic.formatDate(DateTime.now().subtract(Duration(days: day))),
            });
          }
        }

        List<int> months = [0, 1, 12, 24];

        elements.add({
          'type': 'type',
          'label': 'M',
        });

        for (int month in months) {
          if (dataProvider.monthlyConsumptions.length > month) {
            String label = '${dataProvider.monthlyConsumptions[month].year}.${dataProvider.monthlyConsumptions[month].month.toString().padLeft(2, '0')}';
            elements.add({
              'type': 'day',
              'consumption': dataProvider.monthlyConsumptions[month].consumption,
              'label': label,
              'compareWith': dataProvider.monthlyConsumptions.first.consumption,
            });
          } else {
            elements.add({
              'type': 'default',
              'label': '${DateTime.now().subtract(Duration(days: month)).year}.${DateTime.now().subtract(Duration(days: month)).month.toString().padLeft(2, '0')}',
            });
          }
        }

        elements.add({
          'type': 'type',
          'label': 'D',
        });

        for (var averageConsumption in dataProvider.averageConsumptions) {
          averageConsumption.consumption > 0
              ? elements.add({
                  'type': 'average',
                  'consumption': averageConsumption.consumption,
                  'label': averageConsumption.period,
                  'compareWith': dataProvider.averageConsumptions.first.consumption,
                })
              : elements.add({
                  'type': 'default',
                  'label': averageConsumption.period,
                });
        }
        
        List<int> years = [0, 1, 2, 3];

        elements.add({
          'type': 'type',
          'label': 'J',
        });

        for (int year in years) {
          if (dataProvider.yearlyConsumptions.length > year) {
            elements.add({
              'type': 'day',
              'consumption': dataProvider.yearlyConsumptions[year].consumption,
              'label': '${dataProvider.yearlyConsumptions[year].year}',
              'compareWith': dataProvider.yearlyConsumptions.first.consumption,
            });
          } else {
            elements.add({
              'type': 'default',
              'label': '${DateTime.now().year - year}',
            });
          }
        }


        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1.5, // Adjust for desired item height/width ratio
          ),
          itemCount: elements.length,
          itemBuilder: (context, index) {
            if (elements[index]['type'] == 'type') {
              return Align(
                alignment: Alignment.center, // Ensures the Text is centered in the cell
                child: Text(
                  elements[index]['label'],
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize ?? 14) * 1.5,
                      ),
                ),
              );
            } else if (elements[index]['type'] == 'day' || elements[index]['type'] == 'average') {
              return Align(
                alignment: Alignment.center, // Centers the ReadingConsumptionElement in the cell
                child: ReadingConsumptionElement(
                  consumption: elements[index]['consumption'],
                  label: elements[index]['label'],
                  compareConsumptionWith: elements[index]['compareWith'],
                ),
              );
            } else {
              return Align(
                alignment: Alignment.center, // Centers the ReadingConsumptionElement in the cell
                child: ReadingConsumptionElement(
                  label: elements[index]['label'],
                ),
              );
            }
          },
        );
      },
    );
  }
}

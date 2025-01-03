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
        final elements = _buildElements(dataProvider, context); // Pass context here
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1.5,
          ),
          itemCount: elements.length,
          itemBuilder: (context, index) {
            final element = elements[index];
            return Align(
              // Keep the Align widget for consistent centering
              alignment: Alignment.center,
              child: _buildGridItem(element, context), // Use a separate function
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _buildElements(DataProvider dataProvider, BuildContext context) {
    final elements = <Map<String, dynamic>>[];
    final days = [0, 7, 30, 365];
    final months = [0, 1, 12, 24];
    final years = [0, 1, 2, 3];

    _addTypeLabel(elements, 'T');
    _addConsumptionData('day', elements, dataProvider.dailyConsumptions, days,
        (day) => ReadingLogic.formatDate(dataProvider.dailyConsumptions.isNotEmpty ? dataProvider.dailyConsumptions.first.date.subtract(Duration(days: day)) : DateTime.now().subtract(Duration(days: day))));

    _addTypeLabel(elements, 'M');
    _addConsumptionData(
        'month', elements, dataProvider.monthlyConsumptions, months, (month) => '${DateTime.now().subtract(Duration(days: month * 30)).year}.${DateTime.now().subtract(Duration(days: month * 30)).month.toString().padLeft(2, '0')}');

    _addTypeLabel(elements, 'D');
    for (var averageConsumption in dataProvider.averageConsumptions) {
      elements.add({
        'type': averageConsumption.consumption > 0 ? 'average' : 'default',
        'consumption': averageConsumption.consumption,
        'label': averageConsumption.period,
        'compareWith': dataProvider.averageConsumptions.isNotEmpty ? dataProvider.averageConsumptions.first.consumption : null,
      });
    }

    _addTypeLabel(elements, 'J');
    _addConsumptionData('year', elements, dataProvider.yearlyConsumptions, years, (year) => '${DateTime.now().year - year}');

    return elements;
  }

  void _addConsumptionData(String type, List<Map<String, dynamic>> elements, List data, List<int> indices, Function labelGenerator) {
    for (int i = 0; i < indices.length; i++) {
      final index = indices[i];
      if (data.length > index) {
        elements.add({
          'type': type,
          'consumption': data[index].consumption,
          'label': labelGenerator(index),
          'compareWith': data.isNotEmpty ? data.first.consumption : null,
        });
      } else {
        elements.add({
          'type': 'default',
          'label': labelGenerator(index),
        });
      }
    }
  }

  Widget _buildGridItem(Map<String, dynamic> element, BuildContext context) {
    if (element['type'] == 'type') {
      return Text(
        element['label'],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize ?? 14) * 1.5,
            ),
      );
    } else if (element['type'] == 'day' || element['type'] == 'month' || element['type'] == 'year' || element['type'] == 'average') {
      return ReadingConsumptionElement(
        consumption: element['consumption'],
        label: element['label'],
        compareConsumptionWith: element['compareWith'],
      );
    } else {
      return ReadingConsumptionElement(label: element['label']);
    }
  }

  void _addTypeLabel(List<Map<String, dynamic>> elements, String label) {
    elements.add({
      'type': 'type',
      'label': label,
    });
  }
}

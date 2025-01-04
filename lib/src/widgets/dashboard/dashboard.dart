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
        final elements = _buildElements(dataProvider, context);
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
            childAspectRatio: 1.3,
          ),
          itemCount: elements.length,
          itemBuilder: (context, index) {
            final element = elements[index];
            return Align(
              alignment: Alignment.center,
              child: _buildGridItem(element, context),
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
    _addConsumptionData(
      'day',
      elements,
      dataProvider.dailyConsumptions,
      days,
      (day) => ReadingLogic.formatDate(
        dataProvider.dailyConsumptions.isNotEmpty
            ? dataProvider.dailyConsumptions.first.date.subtract(Duration(days: day))
            : DateTime.now().subtract(
                Duration(days: day),
              ),
      ),
    );

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
          'compareWith': data.isNotEmpty ? data.first.consumption : null,
          'minTemperature': data[index].minTemperature,
          'maxTemperature': data[index].maxTemperature,
          'minFeelsLike': data[index].minFeelsLike,
          'maxFeelsLike': data[index].maxFeelsLike,
          'label': labelGenerator(index),
        });
      } else {
        elements.add({
          'type': 'default',
          'label': labelGenerator(index),
        });
      }
    }
  }

  void _addTypeLabel(List<Map<String, dynamic>> elements, String label) {
    elements.add({
      'type': 'type',
      'label': label,
    });
  }

  Widget _buildGridItem(Map<String, dynamic> element, BuildContext context) {
    Widget content;

    if (element['type'] == 'type') {
      content = Text(
        element['label'],
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize ?? 14) * 1.5,
            ),
      );
    } else if (element['type'] == 'day' || element['type'] == 'month' || element['type'] == 'year' || element['type'] == 'average') {
      content = ReadingConsumptionElement(
        consumption: element['consumption'],
        compareConsumptionWith: element['compareWith'],
        minTemperature: element['minTemperature'],
        maxTemperature: element['maxTemperature'],
        minFeelsLike: element['minFeelsLike'],
        maxFeelsLike: element['maxFeelsLike'],
        label: element['label'],

      );
    } else {
      content = ReadingConsumptionElement(label: element['label']);
    }

    // Add divider to the bottom of the content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          thickness: 2,
          height: 2,
        ),
        Expanded(
          child: Center(child: content),
        ),
      ],
    );
  }
}
